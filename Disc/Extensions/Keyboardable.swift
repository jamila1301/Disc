//
//  Keyboardable.swift
//  Disc
//
//  Created by Jamila Mahammadli on 05.10.25.
//

import UIKit
import SnapKit

protocol Keyboardable {
    var targetConstraint: Constraint? { get }
    func startObserveKeyboard(completion: @escaping (CGFloat) -> ())
}

extension Keyboardable where Self: UIViewController {
    
    private func observerKeyboard(completion: @escaping (CGFloat) -> Void) {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil
        ) { notification in
            let value = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue
            let keyboardHeight = value?.cgRectValue.height ?? .zero
            completion(keyboardHeight)
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil
        ) { notification in
            completion(.zero)
        }
    }
    
    func startObserveKeyboard(completion: @escaping (CGFloat) -> ()) {
        observerKeyboard { [weak self] height in
            UIView.animate(withDuration: 0.3) {
                guard height > .zero else {
                    self?.targetConstraint?.update(inset: 16)
                    self?.view.layoutIfNeeded()
                    return
                }
                
                self?.targetConstraint?.update(inset: height)
                self?.view.layoutIfNeeded()
            }
            completion(height)
        }
    }
}
