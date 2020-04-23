//
//  SignInViewModel.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/22.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel {
    
    let signedIn: Driver<Bool>
    
    init(email: Driver<String>, password: Driver<String>, loginTap: Signal<Void>, authService: AuthProtocol) {
        let usernameAndPassword = Driver.combineLatest(email, password) { (email: $0, password: $1) }
        
        signedIn = loginTap.withLatestFrom(usernameAndPassword).flatMapLatest { pair -> Driver<Bool> in
            return authService.signin(email: pair.email, password: pair.password).asDriver(onErrorJustReturn: false)
        }
        
    }
    
}
