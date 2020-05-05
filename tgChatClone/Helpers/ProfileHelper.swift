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
    func onPhotoChange(withName: String) -> Observable<UIImage?>
    func createPhoto(withName name: String, color: UIColor?) -> UIImage?
}

class ProfileHelper: ProfileHelperProtocol {
    
    func onPhotoChange(withName name: String) -> Observable<UIImage?> {
        return Observable.create { [weak self] observer in
            if let nameImage = self?.createPhoto(withName: name, color: .lightGray) {
                observer.onNext(nameImage)
                observer.onCompleted()
            } else {
                observer.onNext(nil)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func createPhoto(withName name: String, color: UIColor?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = color ?? generateRandomColor()
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    private func generateRandomColor() -> UIColor {
        let colors: [UIColor] = [.systemPink, .systemTeal, .systemPurple, .systemGreen]
        let index: Int = Int.random(in: 0...2)
        return colors[index]
    }
}
