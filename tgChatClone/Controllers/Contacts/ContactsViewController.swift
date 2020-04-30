//
//  ContactsViewController.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/17.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa
import RxSwift
import RxCocoa

class ContactsViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private var viewModel: ContactsViewModel?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactUserCell.self, forCellReuseIdentifier: ContactUserCell.cellIdentifier())
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupNavbar()
        setupUI()
    }
    
    private func bindViewModel() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let messageService = MessageService()
        viewModel = ContactsViewModel(uid: uid, messageService: messageService)
        viewModel?.contactPresentItems.drive(tableView.rx.items(cellIdentifier: ContactUserCell.cellIdentifier(), cellType: ContactUserCell.self)) { (tv, contactItem, cell) in
            cell.userLabel.text = contactItem.name
            cell.lastLoginLabel.text = "last seen 2 minutes ago"
        }.disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    
    private func setupNavbar() {
        let addContactBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addContactBtn
        navigationItem.title = "Contacts"
        let addContactTap: Signal<Void> = addContactBtn.rx.tap.asSignal()
        addContactTap.emit(onNext: { [weak self] e in
            self?.present(UINavigationController(rootViewController: AddContactViewController()), animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
