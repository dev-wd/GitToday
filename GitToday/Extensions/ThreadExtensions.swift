//
//  ThreadExtensions.swift
//  GitToday
//
//  Created by Apple on 2020/04/10.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation

extension Thread {
    class func printCurrent() {
        print("\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}
