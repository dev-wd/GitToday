//
//  ContributionColor.swift
//  GitToday
//
//  Created by Mainea on 1/30/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import UIKit

protocol ContributionsRepositoryProtocol {
    func fetchRepository(id: String, completion: @escaping (GitTodayError?) -> Void)
}

class ContributionsRepository: ContributionsRepositoryProtocol {
    private let api: ContributionAPIProtocol = ContributionAPI()
    static let shared = ContributionsRepository()
    var dots: [Dot]? = []
    let formatter = DateFormatter()
    let todayDate: String?
    private init() {
        let now = Date()
        formatter.dateFormat = "yyyy/MM/dd"
        todayDate = formatter.string(from: now)
    }
    
    
    var todayCount: Int {
        var todayCount = 0
        let today = dots?.filter{ $0.id == dots!.count - 1}
        today?.forEach{ todayCount = $0.count}
        
        return todayCount
    }
    
    var weekCount: Int {
        var weekCount = 0
        let week = dots?.filter{ ($0.id <= dots!.count - 1) &&  ($0.id > dots!.count - 8) }
        week?.forEach{ weekCount += $0.count }
        return weekCount
    }
    
    var monthCount: Int {
        var monthCount = 0
        let month = dots?.filter{ ($0.id <= dots!.count - 1) &&  ($0.id > dots!.count - 31) }
        month?.forEach{ monthCount += $0.count }
        return monthCount
    }
    
    // not yet 어떻게 처리할지 고민해야 한다.
    
    var step1: [String] {
        let step1Color: String = "#ebedf0"
        var step1Dates: [String] = []
        let step1 = dots?.filter{ $0.color == step1Color}
        step1?.forEach{ step1Dates.append($0.date) }
        return step1Dates
    }
    
    var step2: [String] {
        let step2Color: String = "#c6e48b"
        var step2Dates: [String] = []
        let step2 = dots?.filter{ $0.color == step2Color}
        step2?.forEach{ step2Dates.append($0.date) }
        return step2Dates
    }
    
    var step3: [String] {
        let step3Color: String = "#7bc96f"
        var step3Dates: [String] = []
        let step3 = dots?.filter{ $0.color == step3Color}
        step3?.forEach{ step3Dates.append($0.date) }
        return step3Dates
    }
    
    var step4: [String] {
        let step4Color: String = "#239a3b"
        var step4Dates: [String] = []
        let step4 = dots?.filter{ $0.color == step4Color}
        step4?.forEach{ step4Dates.append($0.date) }
        return step4Dates
    }
    var step5: [String] {
        let step5Color: String = "#196127"
        var step5Dates: [String] = []
        let step5 = dots?.filter{ $0.color == step5Color}
        step5?.forEach{ step5Dates.append($0.date) }
        return step5Dates
    }
    
    
    func fetchRepository(id: String, completion: @escaping (GitTodayError?) -> Void) {
        api.fetchDots(id: id) { dots, error in
            if error == nil {
                self.dots = dots
                completion(nil)
            } else {
                self.dots = nil
                completion(error)
            }
        }
    }
}
