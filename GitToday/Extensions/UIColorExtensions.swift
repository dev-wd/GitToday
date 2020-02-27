//
//  UIColorExtensions.swift
//  GitToday
//
//  Created by Mainea on 2/26/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0, green: CGFloat((hex & 0x00FF00) >> 8) / 255.0, blue: CGFloat(hex & 0x0000FF) / 255.0, alpha: 1)
    }
}

