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
    let name: String?
    let channelID: String?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case channelID = "channel_id"
    }
}
