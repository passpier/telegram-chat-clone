//
//  SettingsViewModel.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/30.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingsViewModel {
    
    let signedOut: Driver<Bool>
    
    init(signoutTap: Signal<Void>, authService: AuthProtocol) {
        signedOut = signoutTap.flatMapLatest { e -> Driver<Bool> in
            return authService.signout().asDriver(onErrorJustReturn: false)
        }
        
    }
}
