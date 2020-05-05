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
    
    private let messageVC: MessageViewController
    
    private var paddingBottom: CGFloat
    
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
            btn.widthAnchor.constraint(equalToConstant: 40)
        ])
        return btn
    }()
    
    lazy var toolBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "mic"), for: .normal)
        btn.tintColor = .systemGray
        btn.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            btn.heightAnchor.constraint(equalToConstant: 36),
            btn.widthAnchor.constraint(equalToConstant: 40)
        ])
        return btn
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
        
        let stack = UIStackView(arrangedSubviews: [fileBtn, inputField, toolBtn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .bottom
        
        addSubview(stack)
        messageVC.view.addSubview(self)
        bottomConstraint = bottomAnchor.constraint(equalTo: messageVC.view.bottomAnchor)
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        textBottomConstraint = stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingBottom)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            textBottomConstraint,
            leadingAnchor.constraint(equalTo: messageVC.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: messageVC.view.trailingAnchor),
            bottomConstraint,
            heightConstraint
        ])
    }
    
    func textingMessage(_ isTexting: Bool) {
        if isTexting {
             toolBtn.translatesAutoresizingMaskIntoConstraints = false
            toolBtn.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            toolBtn.tintColor = .systemBlue
        } else {
            toolBtn.translatesAutoresizingMaskIntoConstraints = false
            toolBtn.setImage(UIImage(systemName: "mic"), for: .normal)
            toolBtn.tintColor = .systemGray
        }
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
}
