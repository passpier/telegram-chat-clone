//
//  ContactPresentItem.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/30.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit

struct ContactPresentItem: ChatFriendProtocol {
    var friendId: String
    var photo: UIImage?
    var name: String
    var lastLogin: Date
    var channelId: String
}
