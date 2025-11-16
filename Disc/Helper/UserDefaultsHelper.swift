//
//  UserDefaultsHelper.swift
//  Disc
//
//  Created by Jamila Mahammadli on 27.10.25.
//

import Foundation

enum UserDefaultKey: String {
    case appLanguage
}

protocol UserDefaultsHelper {
    func save(key: UserDefaultKey, value: String)
    func get(key: UserDefaultKey) -> String
}

final class UserDefaultsHelperImpl: UserDefaultsHelper {
    
    private let userDefault: UserDefaults = UserDefaults.standard
    
    func save(key: UserDefaultKey, value: String) {
        userDefault.set(value, forKey: key.rawValue)
    }
    
    func get(key: UserDefaultKey) -> String {
        userDefault.string(forKey: key.rawValue) ?? ""
    }
    
}
