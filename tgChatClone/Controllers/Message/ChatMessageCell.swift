//
//  ChatMessageCell.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/5/7.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .black
        tv.isEditable = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xE6, green: 0xFE, blue: 0xCC)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleWidthAnchor = NSLayoutConstraint()
    var outcomingAnchor = NSLayoutConstraint()
    var incomingAnchor = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateIncomingMessaageUI() {
        incomingAnchor.isActive = true
        outcomingAnchor.isActive = false
        bubbleView.backgroundColor = .white
    }
    
    func updateOutcomingMessaageUI() {
        incomingAnchor.isActive = false
        outcomingAnchor.isActive = true
        bubbleView.backgroundColor = UIColor(red: 0xE6, green: 0xFE, blue: 0xCC)
    }
    
    private func setupUI() {
        addSubview(bubbleView)
        bubbleView.addSubview(textView)
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        outcomingAnchor = bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        incomingAnchor = bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        outcomingAnchor.isActive = true
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: topAnchor),
            bubbleWidthAnchor,
            bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
            textView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
        ])
    }
}
