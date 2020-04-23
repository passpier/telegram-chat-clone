//
//  SignUpViewController.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/18.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    private var viewModel: SignUpViewModel?
    
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.text = "Create\nan account"
        tl.font = UIFont.boldSystemFont(ofSize: 30)
        tl.numberOfLines = 2
        return tl
    }()
    
    private lazy var firstNameContainer: ProfileInputView = {
        let v = ProfileInputView(placeholder: "First Name", icon: #imageLiteral(resourceName: "ic_person_outline_white"))
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return v
    }()
    
    private lazy var lastNameContainer: ProfileInputView = {
        let v = ProfileInputView(placeholder: "Last Name", icon: #imageLiteral(resourceName: "ic_person_outline_white"))
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return v
    }()
    
    private lazy var emailContainer: ProfileInputView = {
        let v = ProfileInputView(placeholder: "Email", icon: #imageLiteral(resourceName: "ic_mail_outline_white"))
        v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return v
    }()
    
    private lazy var passwordContainer: ProfileInputView = {
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
        btn.setTitle("Sign In", for: .normal)
        btn.setTitleColor(UIColor(red: 0x17, green: 0x98, blue: 0xc9), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupView()
    }
    
    private func bindViewModel() {
        let authService: AuthProtocol = AuthService()
        viewModel = SignUpViewModel(email: emailContainer.inputField.rx.text.orEmpty.asDriver(), password: passwordContainer.inputField.rx.text.orEmpty.asDriver(), firstName: firstNameContainer.inputField.rx.text.orEmpty.asDriver(), lastName: lastNameContainer.inputField.rx.text.orEmpty.asDriver(), signupTap: signUpButton.rx.tap.asSignal(), authService: authService)
        viewModel?.signedUp
            .drive(onNext: { [weak self] signedUp in
                print("User signed up \(signedUp)")
                if !signedUp {
                    let controller = UIAlertController(title: "Signup Failed", message: "Your email or password is incorrect.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(okAction)
                    self?.present(controller, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
        let backButtonTap: Signal<Void> = backButton.rx.tap.asSignal()
        backButtonTap.emit(onNext: { [weak self] e in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
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
}
