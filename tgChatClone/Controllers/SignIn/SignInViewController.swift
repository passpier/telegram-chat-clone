//
//  SignInViewController.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/18.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    private var viewModel: SignInViewModel?
    
    private let disposeBag = DisposeBag()
    
    private lazy var loginImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.shadowOpacity = 0.2
        iv.layer.shadowColor = UIColor(red: 0x17, green: 0x98, blue: 0xc9).cgColor
        iv.layer.shadowOffset = CGSize(width: 0, height: 10)
        iv.image = #imageLiteral(resourceName: "login_logo")
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to Telegram!"
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return label
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
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(red: 0x17, green: 0x98, blue: 0xc9)
        btn.setTitle("Log in", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 8
        btn.layer.shadowOpacity = 0.1
        btn.layer.shadowColor = UIColor(red: 0x17, green: 0x98, blue: 0xc9).cgColor
        btn.layer.shadowOffset = CGSize(width: 5, height: 5)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    
    private lazy var signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(UIColor(red: 0x17, green: 0x98, blue: 0xc9), for: .normal)
        return btn
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Not a member?"
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupView()
    }
    
    private func bindViewModel() {
        let authService: AuthProtocol = AuthService()
        viewModel = SignInViewModel(email: emailContainer.inputField.rx.text.orEmpty.asDriver(), password: passwordContainer.inputField.rx.text.orEmpty.asDriver(), loginTap: loginButton.rx.tap.asSignal(), authService: authService)
        
        viewModel?.signedIn
        .drive(onNext: { [weak self] signedIn in
            print("User signed in \(signedIn)")
            if !signedIn {
                let controller = UIAlertController(title: "Verification Failed", message: "Your email or password is incorrect.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(okAction)
                self?.present(controller, animated: true, completion: nil)
            } else {
                let root = RootTabBarController()
                root.modalPresentationStyle = .fullScreen
                self?.present(root, animated: false, completion: nil)
            }
        })
        .disposed(by: disposeBag)
        let signUpTap: Signal<Void> = signUpButton.rx.tap.asSignal()
        signUpTap.emit(onNext: { [weak self] e in
            self?.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, emailContainer, passwordContainer, loginButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setCustomSpacing(60, after: titleLabel)
        stack.spacing = 10
        
        let signUpHint = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])
        signUpHint.translatesAutoresizingMaskIntoConstraints = false
        signUpHint.axis = .horizontal
        signUpHint.spacing = 5
        
        view.addSubview(loginImageView)
        view.addSubview(stack)
        view.addSubview(signUpHint)
        
        NSLayoutConstraint.activate([
            loginImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginImageView.heightAnchor.constraint(equalToConstant: 120),
            loginImageView.widthAnchor.constraint(equalToConstant: 120),
            loginImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            stack.topAnchor.constraint(equalTo: loginImageView.bottomAnchor, constant: 30),
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            signUpHint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpHint.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
}
