//
//  Friend.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/26.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation

struct Friend: Codable {
    let uid: String?
    let friendId: String?
    let firstName: String?
    let lastName: String?
    let channelID: String?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case friendId = "friend_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case channelID = "channel_id"
    }
}
