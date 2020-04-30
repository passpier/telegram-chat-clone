//
//  AddContactViewModel.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/26.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AddContactViewModel {
    
    let friendPhoto: Driver<UIImage?>
    let isContactCreated: Driver<Bool>
    
    init(firstName: Driver<String>, lastName: Driver<String>, email: Driver<String>, createTap: Signal<Void>, profileHelper: ProfileHelperProtocol, messageService: MessageProtocol) {
        let userProfile = Driver.combineLatest(firstName, lastName, email) { (firstName: $0, lastName: $1, email: $2) }
        friendPhoto = userProfile.flatMapLatest { pair -> Driver<UIImage?> in
            let firstChar = String(pair.firstName.prefix(1))
            let secondChar = String(pair.lastName.prefix(1))
            let name = firstChar + secondChar
            return profileHelper.createPhotoWith(name: name).asDriver(onErrorJustReturn: nil)
        }
        
        isContactCreated = createTap.withLatestFrom(userProfile).flatMapLatest { pair -> Driver<Bool> in
            return messageService.addFriend(email: pair.email, name: "\(pair.firstName)\(pair.lastName)").asDriver(onErrorJustReturn: false)
        }
    }
    
}
