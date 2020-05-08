//
//  MessageService.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/5/5.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import RxSwift
import RxCocoa

protocol MessageProtocol {
    func sendTextMessage(channelId: String, receiverId: String, textContent: String) -> Observable<Bool>
    func observeMessageList(withChanelId channelId: String) -> Observable<[Message]>
    var fetchMessageListCompleted: PublishSubject<[Message]> { get }
}

class MessageService: MessageProtocol {
    
    let db = Firestore.firestore()
    let fetchMessageListCompleted = PublishSubject<[Message]>()
    
    func observeMessageList(withChanelId channelId: String) -> Observable<[Message]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let notificationToken = self.db.collection("messages").whereField("channel_id", isEqualTo: channelId).order(by: "timestamp").addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    observer.onError(error!)
                    return
                }
                let messages = documents.map { document -> Message in
                    let result = Result {
                        try document.data(as: Message.self)
                    }
                    switch result {
                    case .success(let message):
                        guard let message = message else { return  Message(channelId: "", senderId: "", receiverId: "", timestamp: Date(), textContent: "")}
                        return message
                    case .failure(let error):
                        print("Error decoding message: \(error)")
                        return Message(channelId: "", senderId: "", receiverId: "", timestamp: Date(), textContent: "")
                    }
                }
                observer.onNext(messages)
                self.fetchMessageListCompleted.onNext(messages)
            }
            
            return Disposables.create {
                notificationToken.remove()
            }
        }
    }
    
    func sendTextMessage(channelId: String, receiverId: String, textContent: String) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            self?.addMessageToFirestore(channelId: channelId, receiverId: receiverId, textContent: textContent) { result in
                switch result {
                case .success(let success):
                    print("Add message \(success)!")
                    observer.onNext(true)
                    observer.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    private func addMessageToFirestore(channelId: String, receiverId: String, textContent: String,completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let message = Message(channelId: channelId, senderId: uid, receiverId: receiverId, timestamp: Date(), textContent: textContent)
        print("message: \(message)")
        do {
            _ = try db.collection("messages").addDocument(from: message)
            completionHandler(.success(true))
        } catch let error {
            print("Error writing message to Firestore: \(error)")
            completionHandler(.failure(error))
        }
    }
}
