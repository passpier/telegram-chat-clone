//
//  SettingsViewController.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/17.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private var viewModel: SettingsViewModel?
    
    lazy var signoutBtn: UIBarButtonItem = {
        return UIBarButtonItem(title: "Signout", style: .plain, target: nil, action: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = signoutBtn
        bindViewModel()
    }

    private func bindViewModel() {
        let authService = AuthService()
        viewModel = SettingsViewModel(signoutTap: signoutBtn.rx.tap.asSignal(), authService: authService)
        viewModel?.signedOut.drive(onNext: { signedOut in
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            let nav = UINavigationController(rootViewController: SignInViewController())
            nav.navigationBar.isHidden = true
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }).disposed(by: disposeBag)
    }
    
}
