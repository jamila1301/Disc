//
//  ProfileViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 26.10.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol ProfileViewModelDelegate: AnyObject {
    func reloadTableView()
}

nonisolated enum ProfileCellType: Hashable {
    case profileDetail(AccountDetailTableViewCell.Item)
    case settingsDetail(SettingsTableViewCell.Item)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .profileDetail(let item):
            hasher.combine(0)
            hasher.combine(item)
        case .settingsDetail(let item):
            hasher.combine(1)
            hasher.combine(item)
        }
    }
}

final class ProfileViewModel {
    
    private let db = Firestore.firestore()
    private var profileListener: ListenerRegistration?
    private var router: ProfileRouterProtocol
    weak var delegate: ProfileViewModelDelegate? = nil
    private(set) var cellTypes: [ProfileCellType] = []
    
    init(router: ProfileRouterProtocol) {
        self.router = router
        
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            Task { self?.startListeningProfile() }
        }
    }
    
    @MainActor
    func startListeningProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        profileListener?.remove()
        
        profileListener = db.collection("users").document(uid)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = snapshot?.data() else { return }
                
                let name = data["name"] as? String ?? ""
                let email = data["email"] as? String ?? Auth.auth().currentUser?.email ?? ""
                let firestoreProfileURL = data["profileImageURL"] as? String
                
                let finalProfileURL: String? = {
                    if let url = firestoreProfileURL, !url.isEmpty {
                        return url
                    }
                    if let photoURL = Auth.auth().currentUser?.photoURL?.absoluteString, !photoURL.isEmpty {
                        return photoURL
                    }
                    return nil
                }()
                
                self.cellTypes = [
                    .profileDetail(.init(image: finalProfileURL, name: name, email: email)),
                    .settingsDetail(.init(type: .account, leftImage: .profile2, title: "profile_account_title".localized(), rightImage: .arrowRight)),
                    .settingsDetail(.init(type: .language, leftImage: .language, title: "profile_language_title".localized(), rightImage: .arrowRight)),
                    .settingsDetail(.init(type: .about, leftImage: .about, title: "profile_about_title".localized(), rightImage: .arrowRight)),
                    .settingsDetail(.init(type: .termsAndConditions, leftImage: .terms, title: "profile_terms_title".localized(), rightImage: .arrowRight))
                ]
                
                self.delegate?.reloadTableView()
            }
    }
    
    func removeListener() {
        profileListener?.remove()
    }
    
    func didTapAccount() {
        router.navigateToAccount()
    }
    
    func didTapAbout() {
        router.navigateToAbout()
    }
    
    func didTapTerms() {
        router.navigateToTerms()
    }
    
    func didTapLanguage() {
        router.navigateToLanguage()
    }
}
