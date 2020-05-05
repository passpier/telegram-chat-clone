//
//  MessageViewController.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/5/2.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MessageViewController: UIViewController {

    private var viewModel: MessageViewModel?
    private var inputBottomAnchr = NSLayoutConstraint()
    private var inputHeightAnchr = NSLayoutConstraint()
    
    private let disposeBag = DisposeBag()
    private let chatFriend: ChatFriendProtocol
    
    private var msgInputView: MessageInputView!
    
    private lazy var nameLabel: UILabel = {
        let la = UILabel()
        la.text = self.chatFriend.name
        la.translatesAutoresizingMaskIntoConstraints = false
        return la
    }()
    
    private lazy var lastLoginLabel: UILabel = {
        let la = UILabel()
        la.text = "last seen 2 minutes ago"
        la.translatesAutoresizingMaskIntoConstraints = false
        la.textColor = .lightGray
        la.font = UIFont.systemFont(ofSize: 12)
        return la
    }()
    
    private lazy var photoItem: UIBarButtonItem = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = self.chatFriend.photo
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        NSLayoutConstraint.activate([
            iv.heightAnchor.constraint(equalToConstant: 40),
            iv.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        let navItem = UIBarButtonItem(customView: iv)
        return navItem
    }()
    
    init(chatFriend: ChatFriendProtocol) {
        print("chatFriend: \(chatFriend)")
        self.chatFriend = chatFriend
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        var height: CGFloat = 45
        var paddingBottom: CGFloat = 8
        if view.safeAreaInsets.bottom > 0 {
            height = 75
            paddingBottom = 34
        }else{
            height = 46
            paddingBottom = 8
        }
        msgInputView = MessageInputView(height: height, paddingBottom: paddingBottom, messageVC: self)
        bindViewModel()
        hideKeyboardOnTap()
    }
    
    private func bindViewModel() {
        viewModel = MessageViewModel(keyboardWillShow: NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification), keyboardWillHide: NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification), inputText: msgInputView.inputField.rx.text.orEmpty.asDriver())
        viewModel?.keyboradLayout.subscribe(onNext: { [weak self] info in
            guard let self = self else { return }
            if info.height > 0 {
                if self.msgInputView.height > 46 {
                    self.msgInputView.textBottomConstraint.constant = -5
                    self.msgInputView.heightConstraint.constant = 46
                }
            } else {
                if self.msgInputView.height > 46 {
                    self.msgInputView.textBottomConstraint.constant = -34
                    self.msgInputView.heightConstraint.constant = 75
                }
            }
            
            self.msgInputView.bottomConstraint.constant = -info.height
            UIView.animate(withDuration: info.animDuration) {
                self.view.layoutIfNeeded()
            }
        }).disposed(by: disposeBag)
        
        viewModel?.isTexting.drive(onNext: { [weak self] texting in
            self?.msgInputView.textingMessage(texting)
        }).disposed(by: disposeBag)
    }
    
    private func setupNavBar() {
        let titleStack = UIStackView(arrangedSubviews: [nameLabel, lastLoginLabel])
        titleStack.axis = .vertical
        titleStack.alignment = .center
        navigationItem.titleView = titleStack
        navigationItem.rightBarButtonItem = photoItem
    }
    
    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        tap.rx.event.subscribe(onNext: { [weak self] recognizer in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
}
