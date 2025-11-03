//
//  String+Localization.swift
//  Disc
//
//  Created by Jamila Mahammadli on 27.10.25.
//

import Foundation

extension String {
    func localized() -> String {
        if let path = Bundle.main.path(forResource: LanguageManager.shared.get().rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        return self
    }
}
