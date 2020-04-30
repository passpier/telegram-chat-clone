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
        viewModel?.signedOut.drive(onNext: { [weak self] signedOut in
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let nav = window.rootViewController as? UINavigationController else { return }
            if (nav.viewControllers.first as? RootTabBarController) != nil {
                let signinVC = UINavigationController(rootViewController: SignInViewController())
                signinVC.modalPresentationStyle = .fullScreen
                self?.present(signinVC, animated: false, completion: nil)
            } else {
                self?.dismiss(animated: false, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
}
