//
//  SignUpViewModel.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/23.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    
    let signedUp: Driver<Bool>
    
    init(email: Driver<String>, password: Driver<String>, firstName: Driver<String>, lastName: Driver<String>, signupTap: Signal<Void>, authService: AuthProtocol) {
        let newUserProfile = Driver.combineLatest(email, password, firstName, lastName) { (email: $0, password: $1, firstName: $2, lastName: $3) }
        
        signedUp = signupTap.withLatestFrom(newUserProfile).flatMapLatest { pair -> Driver<Bool> in
            return authService.signup(email: pair.email, password: pair.password, firstName: pair.firstName, lastName: pair.lastName).asDriver(onErrorJustReturn: false)
        }
        
    }
}
