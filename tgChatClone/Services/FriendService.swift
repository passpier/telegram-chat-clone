//
//  MessageService.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/24.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import RxSwift
import RxCocoa

protocol FriendProtocol {
    func addFriend(email: String, firstName: String, lastName: String) -> Observable<Bool>
    func observeFriendList(withUid uid: String) -> Observable<[Friend]>
}

struct UserName {
    var firstName: String
    var lastName: String
}

class FriendService: FriendProtocol {
    
    let db = Firestore.firestore()
    
    func addFriend(email: String, firstName: String = "", lastName: String = "") -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            self?.db.collection("users").whereField("email", isEqualTo: email.lowercased()).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    observer.onError(err)
                } else {
                    guard let document = querySnapshot!.documents.first else {
                        observer.onNext(false)
                        observer.onCompleted()
                        return
                    }
                    print("\(document.documentID) => \(document.data())")
                    guard let user = self?.getUserName(document.data()) else {
                        observer.onNext(false)
                        observer.onCompleted()
                        return
                    }
                    let friendId = document["uid"] as! String
                    self?.addFriendToFirestore(friendId: friendId, firstName: user.firstName, lastName: user.lastName) { result in
                        switch result {
                        case .success(let success):
                            print("Add friend \(success)!")
                            observer.onNext(true)
                            observer.onCompleted()
                        case .failure(let error):
                            print(error.localizedDescription)
                            observer.onError(error)
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func observeFriendList(withUid uid: String) -> Observable<[Friend]>  {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let notificationToken = self.db.collection("contacts").whereField("uid", isEqualTo: uid).addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    observer.onError(error!)
                    return
                }
                
                let friends = documents.map { document -> Friend in
                    let result = Result {
                        try document.data(as: Friend.self)
                    }
                    switch result {
                    case .success(let friend):
                        guard let friend = friend else { return Friend(uid: "", friendId: "", firstName: "", lastName: "", channelID: "")}
                        return friend
                    case .failure(let error):
                        print("Error decoding message: \(error)")
                        return Friend(uid: "", friendId: "", firstName: "", lastName: "", channelID: "")
                    }
                }
                
                
                observer.onNext(friends)
            }
            
            return Disposables.create {
                notificationToken.remove()
            }
        }
    }
    
    private func getUserName(_ dic: [String : Any]) -> UserName {
        guard let firstName = dic["first_name"] as? String else { return UserName(firstName: "", lastName: "") }
        guard let lastName = dic["last_name"] as? String else { return UserName(firstName: firstName, lastName: "") }
        return UserName(firstName: firstName, lastName: lastName)
    }
    
    private func addFriendToFirestore(friendId: String, firstName: String, lastName: String, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let channelID = UUID().uuidString
        let friend = Friend(uid: uid, friendId: friendId, firstName: firstName, lastName: lastName, channelID: channelID)
        do {
            _ = try db.collection("contacts").addDocument(from: friend)
            completionHandler(.success(true))
        } catch let error {
            print("Error writing contacts to Firestore: \(error)")
            completionHandler(.failure(error))
        }
    }
}
