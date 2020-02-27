//
//  KeyIdentifier.swift
//  GitToday
//
//  Created by Mainea on 2/4/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation

enum KeyIdentifier {
    case id
    case notification

    var value: String {
        switch self {
        case .id:
            return "id"
        case .notification:
            return "notification"
        }
    }
}
