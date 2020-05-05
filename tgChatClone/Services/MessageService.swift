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

protocol MessageProtocol {
    func addFriend(email: String, firstName: String, lastName: String) -> Observable<Bool>
    func observeFriendList(withUid uid: String) -> Observable<[ContactItem]>
}

struct UserName {
    var firstName: String
    var lastName: String
}

class MessageService: MessageProtocol {
    
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
                    guard let user = self?.getUserName(document) else {
                        observer.onNext(false)
                        observer.onCompleted()
                        return
                    }
                    self?.addFriendToFirestore(firstName: user.firstName, lastName: user.lastName) { result in
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
    
    func observeFriendList(withUid uid: String) -> Observable<[ContactItem]>  {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let notificationToken = self.db.collection("contacts").whereField("uid", isEqualTo: uid).addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    observer.onError(error!)
                    return
                }
                let contacts = documents.map {contact -> ContactItem in
                    let user = self.getUserName(contact)
                    return ContactItem(firstName: user.firstName, lastName: user.lastName, lastLogin: Date())
                }
                print("Friend list: \(contacts)")
                observer.onNext(contacts)
            }
            
            return Disposables.create {
                notificationToken.remove()
            }
        }
    }
    
    func observeMessage() {
//        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
//            return
//        }
//
//        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
//        userMessagesRef.observe(.childAdded, with: { (snapshot) in
//
//            let messageId = snapshot.key
//            let messagesRef = Database.database().reference().child("messages").child(messageId)
//            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                guard let dictionary = snapshot.value as? [String: AnyObject] else {
//                    return
//                }
//
//                self.messages.append(Message(dictionary: dictionary))
//                DispatchQueue.main.async(execute: {
//                    self.collectionView?.reloadData()
//                    //scroll to the last index
//                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
//                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
//                })
//
//                }, withCancel: nil)
//
//            }, withCancel: nil)
    }
    
    func sendTextMessage() {
        
    }
    
    func sendImageMessage() {
        
    }
    
    func sendAudioMessage() {
        
    }
    
    func sendVideoMessage() {
        
    }
    
    private func getUserName(_ document: QueryDocumentSnapshot) -> UserName {
        print("get user name")
        let dic = document.data()
        guard let firstName = dic["first_name"] as? String else { return UserName(firstName: "", lastName: "") }
        guard let lastName = dic["last_name"] as? String else { return UserName(firstName: firstName, lastName: "") }
        return UserName(firstName: firstName, lastName: lastName)
    }
    
    private func addFriendToFirestore(firstName: String, lastName: String, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let channelID = UUID().uuidString
        let friend = Friend(uid: uid, firstName: firstName, lastName: lastName, channelID: channelID)
        do {
            _ = try db.collection("contacts").addDocument(from: friend)
            completionHandler(.success(true))
        } catch let error {
            print("Error writing contacts to Firestore: \(error)")
            completionHandler(.failure(error))
        }
    }
    
    
//    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
//        let filename = UUID().uuidString + ".mov"
//        
//        let ref = Storage.storage().reference().child("message_movies").child(filename)
//        
//        
//        let uploadTask = ref.putFile(from: url, metadata: nil, completion: { (_, err) in
//            if let err = err {
//                print("Failed to upload movie:", err)
//                return
//            }
//            
//            ref.downloadURL(completion: { (downloadUrl, err) in
//                if let err = err {
//                    print("Failed to get download url:", err)
//                    return
//                }
//                
//                guard let downloadUrl = downloadUrl else { return }
//                
//                if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
//                    
//                    self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
//                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": downloadUrl as AnyObject]
//                        self.sendMessageWithProperties(properties)
//                        
//                    })
//                }
//
//            })
//        })
//
//        uploadTask.observe(.progress) { (snapshot) in
//            if let completedUnitCount = snapshot.progress?.completedUnitCount {
//                self.navigationItem.title = String(completedUnitCount)
//            }
//        }
//
//        uploadTask.observe(.success) { (snapshot) in
//            self.navigationItem.title = self.user?.name
//        }
//    }
//    
//    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
//        let asset = AVAsset(url: fileUrl)
//        let imageGenerator = AVAssetImageGenerator(asset: asset)
//        
//        do {
//        
//            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
//            return UIImage(cgImage: thumbnailCGImage)
//            
//        } catch let err {
//            print(err)
//        }
//        
//        return nil
//    }
//    
//    fileprivate func handleImageSelectedForInfo(_ info: [UIImagePickerController.InfoKey : Any]) {
//        var selectedImageFromPicker: UIImage?
//        
//        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            
//            selectedImageFromPicker = originalImage
//        }
//        
//        if let selectedImage = selectedImageFromPicker {
//            uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
//                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
//            })
//        }
//    }
//    
//    fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
//        let imageName = UUID().uuidString
//        let ref = Storage.storage().reference().child("message_images").child(imageName)
//        
//        if let uploadData = image.jpegData(compressionQuality: 0.2) {
//            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//                
//                if error != nil {
//                    print("Failed to upload image:", error!)
//                    return
//                }
//                
//                ref.downloadURL(completion: { (url, err) in
//                    if let err = err {
//                        print(err)
//                        return
//                    }
//                    completion(url?.absoluteString ?? "")
//                })
//                
//            })
//        }
//    }
}
