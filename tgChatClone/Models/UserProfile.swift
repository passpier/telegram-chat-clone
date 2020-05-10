//
//  UserProfile.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/5/9.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation

class UserProfile: Codable  {
    
    static let shared = UserProfile()
    
    var uid: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumbers: String?
    var profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumbers = "phone_numbers"
        case profileImageUrl = "profile_image_url"
    }
    
    init(uid: String?, firstName: String?, lastName: String?, email: String?) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumbers = ""
        self.profileImageUrl = ""
    }
    
    private init() {
        self.uid = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.phoneNumbers = ""
        self.profileImageUrl = ""
    }
}

