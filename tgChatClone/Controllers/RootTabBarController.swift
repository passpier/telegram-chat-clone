//
//  RootTabBarController.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/17.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit
import FirebaseAuth

class RootTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBarView()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        AuthService().fetchUserProfile(withUid: uid)

    }
    
    private func setupTabBarView() {
        let contacts = setNavigationTab(withRootVC: ContactsViewController(), tabIcon: UIImage(systemName: "person.crop.circle.fill")!, tabTitle: "Contacts")
        let chats = setNavigationTab(withRootVC: ChatsViewController(), tabIcon: UIImage(systemName: "bubble.left.and.bubble.right.fill")!, tabTitle: "Chats")
        let settings = setNavigationTab(withRootVC: SettingsViewController(), tabIcon: UIImage(systemName: "gear")!, tabTitle: "Settings")
        
        viewControllers = [contacts, chats, settings]
    }
    
    
    // MARK: - Helper
    
    private func setNavigationTab(withRootVC rootVC: UIViewController, tabIcon: UIImage, tabTitle: String) -> UIViewController  {
        let vc = UINavigationController(rootViewController: rootVC)
        vc.tabBarItem.image = tabIcon
        vc.tabBarItem.title = tabTitle
        return vc
    }

}
