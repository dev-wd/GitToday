//
//  ContributionAPI.swift
//  GitToday
//
//  Created by Mainea on 1/30/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation
import SwiftSoup

protocol ContributionAPIProtocol  {
    func fetchDots(id: String, completion: @escaping ([Dot]?, GitTodayError?)-> Void)
}


class ContributionAPI : ContributionAPIProtocol {
    
    func fetchDots(id: String, completion: @escaping ([Dot]?, GitTodayError?)-> Void) {
        var dots : [Dot] = []
        if let url = URL(string: "https://github.com/users/"+id+"/contributions") {
            do {
                let contents = try String(contentsOf: url)
                let doc: Document = try SwiftSoup.parse(contents)
                let total: Element = try doc.select("g").first()!
                let totalDots : Elements = total.children()
                for i in 0...52 {
                    let weektotalDots: Elements = totalDots.get(i).children()
                    for j in 0...weektotalDots.count-1 {
                        let dataDate : String = try weektotalDots.get(j).attr("data-date")
                        dots.append(Dot(id: i*7 + j,
                                        date: dataDate,
                                        color: try weektotalDots.get(j).attr("fill"),
                                        count: Int(try weektotalDots.get(j).attr("data-count"))!))
                    }
                }
                completion(dots, nil)
            } catch {
                completion(nil, GitTodayError.networkError)
            }
        } else {
            print("invalid url")
            completion(nil, GitTodayError.networkError)
        }
    }
}
