//
//  LanguageManager.swift
//  Disc
//
//  Created by Jamila Mahammadli on 27.10.25.
//

import Foundation

enum Language: String, CaseIterable {
    case az
    case en
    case ru
    
    var name: String {
        switch self {
        case .az:
            return "language_az".localized()
        case .en:
            return "language_en".localized()
        case .ru:
            return "language_ru".localized()
        }
    }
}

final class LanguageManager {
    private let userDefaults: UserDefaultsHelper = UserDefaultsHelperImpl.shared
    
    static let shared = LanguageManager ()
    
    private var languageChangeCallbacks: [() -> Void] = []
    
    private(set) var current: Language = .en
    
    init() {
        if let saved = userDefaults.get(key: .appLanguage) as String?,
           let lang = Language(rawValue: saved) {
            current = lang
        }
    }
    
    func set(language: Language) {
        current = language
        userDefaults.save(key: .appLanguage, value: language.rawValue)
        languageChangeCallbacks.forEach { $0() }
    }
    
    func get() -> Language {
        return current
    }
    
    func addLanguageChangeListener(_ callback: @escaping () -> Void) {
        languageChangeCallbacks.append(callback)
    }
}
