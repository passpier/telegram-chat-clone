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
    
    init(uid: String, messageService: MessageProtocol, profileHelper: ProfileHelperProtocol) {
        contactPresentItems = messageService.observeFriendList(withUid: uid).flatMapLatest { contactItems -> Observable<[ContactPresentItem]> in
            let presentItems: [ContactPresentItem] = contactItems.map { contactItem in
                let fullName = "\(contactItem.firstName) \(contactItem.lastName)"
                let firstChar = String(contactItem.firstName.prefix(1))
                let secondChar = String(contactItem.lastName.prefix(1))
                let name = firstChar + secondChar
                guard let photo = profileHelper.createPhoto(withName: name, color: nil) else {
                    return ContactPresentItem(photo: nil, name: fullName, lastLogin: contactItem.lastLogin)
                }
                return ContactPresentItem(photo: photo, name: fullName, lastLogin: contactItem.lastLogin)
            }
            return Observable.of(presentItems)
        }.asDriver(onErrorJustReturn: [])
    }
    
}
