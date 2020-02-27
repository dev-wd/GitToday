//
//  UserDefaultAPI.swift
//  GitToday
//
//  Created by Mainea on 1/31/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import Foundation

protocol UserDefaultAPIProtocol {
    func save<T>(_ data: T, of type: KeyIdentifier)
    func load<T>(of type: KeyIdentifier) -> T?
    func delete(of type: KeyIdentifier)
}

class UserIDAPI: UserDefaultAPIProtocol {
    private var userDefaults = UserDefaults(suiteName: "GitTodayID")
    
    func save<T>(_ data: T, of type: KeyIdentifier) {
        userDefaults?.set(data, forKey: type.value)
    }
    
    func load<T>(of type: KeyIdentifier) -> T? {
        return userDefaults?.value(forKey: type.value) as? T
    }
    
    func delete(of type: KeyIdentifier) {
        userDefaults?.removeObject(forKey: type.value)
    }
}

class UserInfoAPI: UserDefaultAPIProtocol {
    private var userDefaults: UserDefaults?
    
    init(_ suiteName: String) {
        self.userDefaults = UserDefaults(suiteName: suiteName)
    }
    
    func save<T>(_ data: T, of type: KeyIdentifier) {
        userDefaults?.set(data, forKey: type.value)
    }
    
    func load<T>(of type: KeyIdentifier) -> T? {
        return userDefaults?.value(forKey: type.value) as? T
    }
    
    func delete(of type: KeyIdentifier) {
        userDefaults?.removeObject(forKey: type.value)
    }
}
