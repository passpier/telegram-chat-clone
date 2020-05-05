//
//  ChatUser.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/5/3.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit

protocol ChatFriendProtocol {
    var photo: UIImage? { get }
    var name: String { get }
    var lastLogin: Date { get }
}
