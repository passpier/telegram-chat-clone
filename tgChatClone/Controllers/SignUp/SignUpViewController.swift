//
//  SignUpViewController.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/18.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.text = "Create\nan account"
        tl.font = UIFont.boldSystemFont(ofSize: 30)
        tl.numberOfLines = 2
        return tl
    }()
    
    private lazy var firstNameContainer: UIView = {
        let v = ProfileInputView(placeholder: "First Name", icon: #imageLiteral(resourceName: "ic_person_outline_white"))
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return v
    }()
    
    private lazy var lastNameContainer: UIView = {
       let v = ProfileInputView(placeholder: "Last Name", icon: #imageLiteral(resourceName: "ic_person_outline_white"))
       v.heightAnchor.constraint(equalToConstant: 50).isActive = true
       return v
    }()
    
    private lazy var emailContainer: UIView = {
       let v = ProfileInputView(placeholder: "Email", icon: #imageLiteral(resourceName: "ic_mail_outline_white"))
       v.heightAnchor.constraint(equalToConstant: 50).isActive = true
       return v
    }()
    
    private lazy var passwordContainer: UIView = {
       let v = ProfileInputView(placeholder: "Password", icon: #imageLiteral(resourceName: "ic_lock_outline_white"), isSecureText: true)
       v.heightAnchor.constraint(equalToConstant: 50).isActive = true
       return v
    }()
    
    private lazy var signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(red: 0x17, green: 0x98, blue: 0xc9)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 8
        btn.layer.shadowOpacity = 0.1
        btn.layer.shadowColor = UIColor(red: 0x17, green: 0x98, blue: 0xc9).cgColor
        btn.layer.shadowOffset = CGSize(width: 5, height: 5)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Already have an account?"
        label.textColor = UIColor(red: 0xB0, green: 0xB0, blue: 0xB0)
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("SignIn", for: .normal)
        btn.setTitleColor(UIColor(red: 0x17, green: 0x98, blue: 0xc9), for: .normal)
        btn.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, firstNameContainer, lastNameContainer, emailContainer, passwordContainer, signUpButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setCustomSpacing(30, after: titleLabel)
        stack.spacing = 10
        
        let signInHint = UIStackView(arrangedSubviews: [signInLabel, backButton])
        signInHint.translatesAutoresizingMaskIntoConstraints = false
        signInHint.axis = .horizontal
        signInHint.spacing = 5
        
        view.addSubview(stack)
        view.addSubview(signInHint)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            signInHint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInHint.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    @objc private func backBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func createUser() {
//        Auth.auth().createUser(withEmail: <#T##String#>, password: <#T##String#>, completion: <#T##AuthDataResultCallback?##AuthDataResultCallback?##(AuthDataResult?, Error?) -> Void#>)
    }
}
