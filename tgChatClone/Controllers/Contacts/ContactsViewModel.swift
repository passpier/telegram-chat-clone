//
//  ContactsViewModel.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/30.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ContactsViewModel {
    
    var contactPresentItems: Driver<[ContactPresentItem]>
    
    init(uid: String, friendService: FriendProtocol, profileHelper: ProfileHelperProtocol) {
        contactPresentItems = friendService.observeFriendList(withUid: uid).flatMapLatest { contactItems -> Observable<[ContactPresentItem]> in
            let presentItems: [ContactPresentItem] = contactItems.map { friend in
                let fullName = "\(friend.firstName!) \(friend.lastName!)"
                let firstChar = String(friend.firstName!.prefix(1))
                let secondChar = String(friend.lastName!.prefix(1))
                let name = firstChar + secondChar
                guard let photo = profileHelper.createPhoto(withName: name, color: nil) else {
                    return ContactPresentItem(friendId:friend.friendId! ,photo: nil, name: fullName, lastLogin: Date(), channelId: friend.channelID!)
                }
                return ContactPresentItem(friendId:friend.friendId!, photo: photo, name: fullName, lastLogin: Date(), channelId: friend.channelID!)
            }
            return Observable.of(presentItems)
        }.asDriver(onErrorJustReturn: [])
    }
    
}
