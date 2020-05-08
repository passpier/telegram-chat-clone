//
//  UITableViewCell+Identifier.swift
//  tgChatClone
//
//  Created by vincent cheng on 2020/4/30.
//  Copyright © 2020 PSC. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
