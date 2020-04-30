//
//  ContactUserCell.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/24.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit

class ContactUserCell: UITableViewCell {
    
    private lazy var photo: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        NSLayoutConstraint.activate([
            iv.heightAnchor.constraint(equalToConstant: 40),
            iv.widthAnchor.constraint(equalToConstant: 40)
        ])
        return iv
    }()
    
    lazy var userLabel: UILabel = {
        let la = UILabel()
        la.translatesAutoresizingMaskIntoConstraints = false
        return la
    }()
    
    lazy var lastLoginLabel: UILabel = {
        let la = UILabel()
        la.translatesAutoresizingMaskIntoConstraints = false
        la.textColor = .lightGray
        la.font = UIFont.systemFont(ofSize: 12)
        return la
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupUI() {
        let nameStack = UIStackView(arrangedSubviews: [userLabel, lastLoginLabel])
        nameStack.axis = .vertical
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView(arrangedSubviews: [photo, nameStack])
        mainStack.axis = .horizontal
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.spacing = 10
        mainStack.alignment = .center
        
        contentView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            mainStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

}
