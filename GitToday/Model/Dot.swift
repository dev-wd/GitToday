//
//  Dot.swift
//  GitToday
//
//  Created by Mainea on 1/30/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation

import UIKit

struct Dot {
    let id : Int
    let date : String
    let color : String
    let count : Int
    var customColor : String?
    
    init(id: Int, date: String, color: String, count: Int) {
        self.id = id
        self.date = date
        self.color = color
        self.count = count
    }
}

