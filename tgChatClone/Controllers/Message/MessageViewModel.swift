//
//  MessageViewModel.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/5/4.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct KeyboardLayout {
    var height: CGFloat
    var animDuration: Double
}

class MessageViewModel {
    
    let keyboradLayout: Observable<KeyboardLayout>
    let isTexting: Driver<Bool>
    
    init(keyboardWillShow: Observable<Notification>, keyboardWillHide: Observable<Notification>, inputText: Driver<String>) {
        keyboradLayout = Observable.from([
            keyboardWillShow.map { notification -> KeyboardLayout in
                let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                guard let height = frame?.height else { return KeyboardLayout(height: 0, animDuration: 0) }
                guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return KeyboardLayout(height: 0, animDuration: 0) }
                return KeyboardLayout(height: height, animDuration: duration)
            },
            keyboardWillHide.map { notification -> KeyboardLayout in
                guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return KeyboardLayout(height: 0, animDuration: 0) }
                return KeyboardLayout(height: 0, animDuration: duration)
            }
        ]).merge()
        
        isTexting = inputText.flatMapLatest { text -> Driver<Bool> in
            return Observable.just(text.count > 0).asDriver(onErrorJustReturn: false)
        }
        
    }
}
