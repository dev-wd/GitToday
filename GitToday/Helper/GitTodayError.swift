//
//  GitTodayError.swift
//  GitToday
//
//  Created by Mainea on 2/4/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation

enum GitTodayError: Error {
    case pageNotFoundError
    case networkError
    case userIDLoadError
    case userIDSaveError
}
