//
//  ContactsViewController.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/17.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ContactsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        logout()
//
//        let db = Firestore.firestore()
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "first": "Ada",
//            "last": "Lovelace",
//            "born": 1815
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print("Logout error: \(err.localizedDescription)")
        }
        
    }

}
