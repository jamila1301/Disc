//
//  CustomTextField.swift
//  Disc
//
//  Created by Jamila Mahammadli on 03.10.25.
//

import UIKit
import SnapKit

final class CustomTextField: UIView {
    
    var placeholder: String {
        get {
            textField.placeholder ?? ""
        }
        set {
            textField.attributedPlaceholder = NSAttributedString(
                string: newValue,
                attributes: [.foregroundColor: UIColor.lightGrayBorder]
            )
        }
    }
    
    var isSecureTextEntry: Bool {
        get {
            textField.isSecureTextEntry
        }
        set {
            textField.isSecureTextEntry = newValue
        }
    }
    
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    private let textField: UITextField = {
        let v = UITextField()
        v.borderStyle = .none
        v.backgroundColor = .clear
        v.isSecureTextEntry = true
        v.autocapitalizationType = .none
        return v
    }()
    
    private lazy var rightButton: UIButton = {
        let v = UIButton(type: .system)
        v.tintColor = .black
        v.isHidden = true
        v.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGrayTextfield.cgColor
        
        addSubview(textField)
        addSubview(rightButton)
        
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rightButton.snp.leading).offset(-8)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    func showPasswordToggleButton(show: Bool) {
        rightButton.isHidden = !show
        if show {
            updateRightButtonIcon()
        }
    }
    
    private func updateRightButtonIcon() {
        let iconName: UIImage = textField.isSecureTextEntry ? .eyeClosedIcon : .eyeIcon
        rightButton.setImage(iconName, for: .normal)
    }
    
    @objc private func rightButtonTapped() {
        isSecureTextEntry.toggle()
        updateRightButtonIcon()
    }
    
}
