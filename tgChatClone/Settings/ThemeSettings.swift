//
//  ThemeSettings.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/19.
//  Copyright © 2020 PSC. All rights reserved.
//

import Foundation
import UIKit

struct ThemeSettings {
    
    var appColor: UIColor
    
    init() {
        self.appColor = UIColor(red: 0x17, green: 0x98, blue: 0xc9)
    }
    
    static var defaultSettings: ThemeSettings {
        return ThemeSettings()
    }
}

