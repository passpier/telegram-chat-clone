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
    
    init(uid: String, messageService: MessageProtocol) {
        contactPresentItems = messageService.observeFriendList(withUid: uid).asDriver(onErrorJustReturn: [])
    }
    
}
