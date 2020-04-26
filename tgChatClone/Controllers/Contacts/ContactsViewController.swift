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

class ContactsViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavbar()
    }
    
    private func setupNavbar() {
        let addContactBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addContactBtn
        let addContactTap: Signal<Void> = addContactBtn.rx.tap.asSignal()
        addContactTap.emit(onNext: { [weak self] e in
            self?.present(UINavigationController(rootViewController: AddContactViewController()), animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

}
