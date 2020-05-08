//
//  MessageViewController.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/5/2.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class MessageViewController: UIViewController {

    private var viewModel: MessageViewModel?
    private var inputBottomAnchr = NSLayoutConstraint()
    private var inputHeightAnchr = NSLayoutConstraint()
    
    private let disposeBag = DisposeBag()
    private let chatFriend: ChatFriendProtocol
    
    private var msgInputView: MessageInputView!
    private var messages = [Message]()
    private var messagesDictionary = [Int: Message]()
    
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
    
    private lazy var bgImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "message_background"))
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        cv.backgroundColor = .clear
        cv.keyboardDismissMode = .interactive
        cv.register(ChatMessageCell.self, forCellWithReuseIdentifier: ChatMessageCell.cellIdentifier())
        return cv
    }()
    
    init(chatFriend: ChatFriendProtocol) {
        self.chatFriend = chatFriend
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupBackground()
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
        setupChatMessagesUI()
        hideKeyboardOnTap()
    }
    
    private func bindViewModel() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let messageService = MessageService()
        viewModel = MessageViewModel(channelId: chatFriend.channelId, friendId: chatFriend.friendId, messageService: messageService)
        
        let input = MessageViewModel.Input(keyboardWillShow: NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification), keyboardWillHide: NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification), inputText: msgInputView.inputField.rx.text.orEmpty.asDriver(), sendTap: msgInputView.sendBtn.rx.tap.asSignal())
        
        guard let output = viewModel?.transform(input: input) else { return }
        output.fetchedMessages.drive(collectionView.rx.items(cellIdentifier: ChatMessageCell.cellIdentifier(), cellType: ChatMessageCell.self)) { [weak self] (cv, message, cell) in
            if let size = self?.calculateFrameInText(message: message.textContent ?? "") {
                cell.bubbleWidthAnchor.constant = size.width + 32
            }
            cell.textView.text = message.textContent
            if (message.senderId == uid) {
                cell.updateOutcomingMessaageUI()
            } else {
                cell.updateIncomingMessaageUI()
            }
            
        }.disposed(by: disposeBag)
        
        output.fetchMessageListCompleted.subscribe(onNext: { [weak self] messages in
            self?.messages = messages
            self?.scrollToTheBottom(animated: false)
            
        }).disposed(by: disposeBag)
        
        output.keyboradLayout.subscribe(onNext: { [weak self] info in
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
        
        output.isTyping.drive(onNext: { [weak self] texting in
            self?.msgInputView.textingMessage(texting)
        }).disposed(by: disposeBag)
        
        output.isMessageSent.drive(onNext: { [weak self] isSent in
            self?.msgInputView.inputField.text = ""
            self?.scrollToTheBottom(animated: false)
        }).disposed(by: disposeBag)
        
    }
    
    private func setupNavBar() {
        let titleStack = UIStackView(arrangedSubviews: [nameLabel, lastLoginLabel])
        titleStack.axis = .vertical
        titleStack.alignment = .center
        navigationItem.titleView = titleStack
        navigationItem.rightBarButtonItem = photoItem
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
        view.clipsToBounds = true
        let iv = UIImageView(image: #imageLiteral(resourceName: "message_background"))
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        view.addSubview(bgImageView)
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupChatMessagesUI() {
        
        //collectionView.backgroundView = bgImageView
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: msgInputView.topAnchor)
        ])
    }
    
    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        
        tap.rx.event.subscribe(onNext: { [weak self] recognizer in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    private func scrollToTheBottom(animated: Bool){
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
        }
    }
}

extension MessageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let message = messages[indexPath.row]
        let cellHeight: CGFloat = calculateFrameInText(message: message.textContent ?? "").height + 32
        return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)
    }
    
    func calculateFrameInText(message: String) -> CGRect{
        return NSString(string: message).boundingRect(with: CGSize(width: 200, height: 9999999), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica Neue", size: 16)!], context: nil)
    }
}
