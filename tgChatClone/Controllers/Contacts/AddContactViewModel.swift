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
    
    init(firstName: Driver<String>, lastName: Driver<String>, profileHelper: ProfileHelperProtocol) {
        let username = Driver.combineLatest(firstName, lastName) { (firstName: $0, lastName: $1) }
        friendPhoto = username.flatMapLatest { pair -> Driver<UIImage?> in
            let firstChar = String(pair.firstName.prefix(1))
            let secondChar = String(pair.lastName.prefix(1))
            let name = firstChar + secondChar
            return profileHelper.createPhotoWith(name: name).asDriver(onErrorJustReturn: nil)
        }
        
    }
    
}
