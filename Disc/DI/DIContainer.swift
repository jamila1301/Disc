//
//  DIContainer.swift
//  Disc
//
//  Created by Jamila Mahammadli on 15.11.25.
//

import Foundation

final class DIContainer {
    
    static let shared = DIContainer()
    
    private init() { }
    
    lazy var networkService: ITunesNetworkServiceProtocol = {
        ITunesService()   
    }()
    
    lazy var userDefaultsHelper: UserDefaultsHelper = {
        UserDefaultsHelperImpl()
    }()
    
    lazy var playerManager: PlayerManager = {
        PlayerManager()
    }()
    
    lazy var languageManager: LanguageManager = {
        LanguageManager()
    }()
    
    lazy var storageManager: FirebaseStorageManager = {
        FirebaseStorageManager()
    }()
    
    lazy var firestoreManager: FirestoreManager = {
        FirestoreManager()
    }()
}
