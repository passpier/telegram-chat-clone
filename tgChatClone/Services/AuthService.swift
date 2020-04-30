//
//  AuthService.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/22.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol AuthProtocol {
    func signin(email: String, password: String) -> Observable<Bool>
    func signup(email: String, password: String, firstName: String, lastName: String) -> Observable<Bool>
    func signout() -> Observable<Bool>
}

struct UserProfile: Codable  {
    
    let firstName: String?
    let lastName: String?
    let email: String?
    let phoneNumbers: String?
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumbers = "phone_numbers"
        case profileImageUrl = "profile_image_url"
    }
}

class AuthService: AuthProtocol {
    
    func signin(email: String, password: String) -> Observable<Bool> {
        return Observable.create { observer in
            print("email: \(email), password: \(password)")
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error: ", error.localizedDescription)
                    observer.onError(error)
                } else {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func signup(email: String, password: String, firstName: String, lastName: String) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            print("email: \(email), password: \(password)")
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error: ", error.localizedDescription)
                    observer.onError(error)
                } else if let uid = authResult?.user.uid {
                    let profile = UserProfile(firstName: firstName, lastName: lastName, email: email.lowercased(), phoneNumbers: "", profileImageUrl: "")
                    self?.createNewUser(withUid: uid, profile: profile) { result in
                        switch result {
                        case .success(let success):
                            print("Add new user \(success)!")
                            observer.onNext(true)
                            observer.onCompleted()
                        case .failure(let error):
                            print(error.localizedDescription)
                            observer.onError(error)
                        }
                    }
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func signout() -> Observable<Bool> {
        return Observable.create { observer in
            do {
                try Auth.auth().signOut()
                observer.onNext(true)
                observer.onCompleted()
            } catch let err {
                print("Logout error: \(err.localizedDescription)")
                observer.onError(err)
            }
            return Disposables.create()
        }
    }
    
    private func createNewUser(withUid uid: String, profile: UserProfile, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        print("uid: \(uid)")
        print("profile: \(profile)")
        let db = Firestore.firestore()
        do {
            try db.collection("users").document(uid).setData(from: profile)
            completionHandler(.success(true))
        } catch let error {
            print("Error writing users to Firestore: \(error)")
            completionHandler(.failure(error))
        }
    }
}
