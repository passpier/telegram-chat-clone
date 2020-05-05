//
//  MessageInputView.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/5/4.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit

class MessageInputView: UIView {

    let height: CGFloat
    var bottomConstraint = NSLayoutConstraint()
    var heightConstraint = NSLayoutConstraint()
    var textBottomConstraint = NSLayoutConstraint()
    
    private weak var messageVC: MessageViewController!
    
    private var paddingBottom: CGFloat
    private var mainStack: UIStackView!
    
    lazy var inputField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 34))
        tf.leftView = someView
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 17
        tf.layer.borderWidth = 0.2
        tf.layer.borderColor = UIColor.systemGray.cgColor
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.attributedPlaceholder = NSAttributedString(string: "Message", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.heightAnchor.constraint(equalToConstant: 34).isActive = true
        return tf
    }()
    
    lazy var fileBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "paperclip"), for: .normal)
        btn.tintColor = .systemGray
        btn.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            btn.heightAnchor.constraint(equalToConstant: 36),
            btn.widthAnchor.constraint(equalToConstant: 36)
        ])
        return btn
    }()
    
    lazy var micBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "mic"), for: .normal)
        btn.tintColor = .systemGray
        btn.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            btn.heightAnchor.constraint(equalToConstant: 36),
            btn.widthAnchor.constraint(equalToConstant: 36)
        ])
        return btn
    }()
    
    lazy var sendBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        btn.layer.cornerRadius = 18
        btn.backgroundColor = .systemBlue
        btn.tintColor = .white
        btn.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            btn.heightAnchor.constraint(equalToConstant: 36),
            btn.widthAnchor.constraint(equalToConstant: 36)
        ])
        return btn
    }()
    
    private lazy var topLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .separator
        v.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return v
    }()
    
    init(height: CGFloat, paddingBottom: CGFloat, messageVC: MessageViewController) {
        self.height = height
        self.paddingBottom = paddingBottom
        self.messageVC = messageVC
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        translatesAutoresizingMaskIntoConstraints = false
        
        mainStack = UIStackView(arrangedSubviews: [fileBtn, inputField, micBtn, sendBtn])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .horizontal
        mainStack.alignment = .bottom
        mainStack.spacing = 4
        let sendBtnView = mainStack.arrangedSubviews[3]
        sendBtnView.isHidden = true
        
        addSubview(topLine)
        addSubview(mainStack)
        messageVC.view.addSubview(self)
        bottomConstraint = bottomAnchor.constraint(equalTo: messageVC.view.bottomAnchor)
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        textBottomConstraint = mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingBottom)
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: topAnchor),
            topLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            mainStack.topAnchor.constraint(equalTo: topLine.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            textBottomConstraint,
            
            leadingAnchor.constraint(equalTo: messageVC.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: messageVC.view.trailingAnchor),
            bottomConstraint,
            heightConstraint
        ])
    }
    
    func textingMessage(_ isTexting: Bool) {
        let sendBtnView = mainStack.arrangedSubviews[3]
        let micBtnView = mainStack.arrangedSubviews[2]
        if isTexting {
            sendBtnView.isHidden = false
            micBtnView.isHidden = true
        } else {
            sendBtnView.isHidden = true
            micBtnView.isHidden = false
        }
    }
}
