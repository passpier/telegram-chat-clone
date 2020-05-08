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
    
    struct Input {
        let keyboardWillShow: Observable<Notification>
        let keyboardWillHide: Observable<Notification>
        let inputText: Driver<String>
        let sendTap: Signal<Void>
    }
    
    struct Output {
        let keyboradLayout: Observable<KeyboardLayout>
        let isTyping: Driver<Bool>
        let isMessageSent: Driver<Bool>
        let fetchedMessages: Driver<[Message]>
        let fetchMessageListCompleted: PublishSubject<[Message]>
    }
    
    private let channelId: String
    private let friendId: String
    private let messageService: MessageProtocol
    
    
    init(channelId: String, friendId: String, messageService: MessageProtocol) {
        self.channelId = channelId
        self.friendId = friendId
        self.messageService = messageService
    }
    
    func transform(input: Input) -> Output {
        let keyboradLayout = getKeyboardLayout(keyboardWillShow: input.keyboardWillShow, keyboardWillHide: input.keyboardWillHide)
        let isTyping = checkIfKeyboardTyping(inputText: input.inputText)
        let isMessageSent = sendMessage(channelId: channelId, friendId: friendId, inputText: input.inputText, sendTap: input.sendTap)
        let fetchedMessages = fetchMessages()
        let fetchMessageListCompleted = messageService.fetchMessageListCompleted
        
        return Output(keyboradLayout: keyboradLayout, isTyping: isTyping, isMessageSent: isMessageSent, fetchedMessages: fetchedMessages, fetchMessageListCompleted:fetchMessageListCompleted)
    }
    
    private func getKeyboardLayout(keyboardWillShow: Observable<Notification>, keyboardWillHide: Observable<Notification>) -> Observable<KeyboardLayout> {
        return Observable.from([
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
    }
    
    private func checkIfKeyboardTyping(inputText: Driver<String>) -> Driver<Bool> {
        return inputText.flatMapLatest { text -> Driver<Bool> in
            return Observable.just(text.count > 0).asDriver(onErrorJustReturn: false)
        }
    }
    
    private func sendMessage(channelId: String, friendId: String, inputText: Driver<String>, sendTap: Signal<Void>) -> Driver<Bool> {
        return sendTap.withLatestFrom(inputText).flatMapFirst { [weak self] content -> Driver<Bool> in
            guard let self = self else { return Driver.just(false) }
            return self.messageService.sendTextMessage(channelId: channelId, receiverId: friendId, textContent: content).asDriver(onErrorJustReturn: false)
        }
    }
    
    private func fetchMessages() -> Driver<[Message]> {
        return messageService.observeMessageList(withChanelId: channelId).asDriver(onErrorJustReturn: [])
    }
}
