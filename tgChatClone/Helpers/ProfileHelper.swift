//
//  ProfileHelper.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/26.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProfileHelperProtocol {
    func createPhotoWith(name: String?) -> Observable<UIImage?>
}

struct ProfileHelper: ProfileHelperProtocol {
    
    func createPhotoWith(name: String?) -> Observable<UIImage?> {
        return Observable.create { observer in
            let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            let nameLabel = UILabel(frame: frame)
            nameLabel.textAlignment = .center
            nameLabel.backgroundColor = .lightGray
            nameLabel.textColor = .white
            nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
            nameLabel.text = name
            UIGraphicsBeginImageContext(frame.size)
            if let currentContext = UIGraphicsGetCurrentContext() {
                nameLabel.layer.render(in: currentContext)
                let nameImage = UIGraphicsGetImageFromCurrentImageContext()
                observer.onNext(nameImage)
                observer.onCompleted()
            }
            observer.onNext(nil)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
