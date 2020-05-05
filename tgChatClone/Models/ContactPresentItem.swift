//
//  ContactPresentItem.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/30.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit

struct ContactItem {
    var firstName: String
    var lastName: String
    var lastLogin: Date
}

struct ContactPresentItem: ChatFriendProtocol {
    var photo: UIImage?
    var name: String
    var lastLogin: Date
}


