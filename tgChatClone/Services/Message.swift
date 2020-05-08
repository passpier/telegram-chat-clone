//
//  Message.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/5/5.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation

struct Message: Codable {
    let channelId: String?
    let senderId: String?
    let receiverId: String?
    let timestamp: Date?
    let textContent: String?
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case timestamp
        case textContent = "text_content"
    }
}
