//
//  ChatPresentItem.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/5/3.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit

struct ChatPresentItem: ChatFriendProtocol {
    var photo: UIImage?
    var name: String
    var lastLogin: Date
    var lastMessage: String
}
