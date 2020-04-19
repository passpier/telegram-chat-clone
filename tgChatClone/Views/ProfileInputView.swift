//
//  ProfileInputView.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/19.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit

class ProfileInputView: UIView {

    private let placeHolder: String
    private let icon: UIImage
    private let isSecureText: Bool
    
    private lazy var iconContainer: UIView = {
        let c = UIView()
        c.backgroundColor = UIColor(red: 0x17, green: 0x98, blue: 0xc9)
        c.translatesAutoresizingMaskIntoConstraints = false
       return c
    }()
    
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = icon
        return iv
    }()
    
    private lazy var inputField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = isSecureText
        tf.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0xB0, green: 0xB0, blue: 0xB0)])
        return tf
    }()
    
    init(placeholder: String, icon: UIImage, isSecureText: Bool = false) {
        self.placeHolder = placeholder
        self.icon = icon
        self.isSecureText = isSecureText
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0xEE, green: 0xEE, blue: 0xEE)
        clipsToBounds = true
        layer.cornerRadius = 8
        
        iconContainer.addSubview(iconImageView)
        addSubview(iconContainer)
        addSubview(inputField)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            
            iconContainer.leftAnchor.constraint(equalTo: leftAnchor),
            iconContainer.heightAnchor.constraint(equalTo: heightAnchor),
            iconContainer.widthAnchor.constraint(equalTo: heightAnchor),
            
            inputField.leftAnchor.constraint(equalTo: iconContainer.rightAnchor, constant: 15),
            inputField.rightAnchor.constraint(equalTo: rightAnchor),
            inputField.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }

}
