//
//  ForgotPasswordViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 05.10.25.
//

import UIKit
import SnapKit

final class ForgotPasswordViewController: UIViewController, Keyboardable {
    
    private let authManager = FirebaseAuthManagerImpl()
    
    var targetConstraint: Constraint? = nil
    
    private let topLabel: UILabel = {
        let v = UILabel()
        v.text = "Forgot password"
        v.font = UIFont.plusJakartaSansSemibold24
        return v
    }()
    
    private let topTitleLabel: UILabel = {
        let v = UILabel()
        v.text = "We will send you an email for your password"
        v.font = UIFont.plusJakartaSansRegular16
        v.textColor = .lightGrayPrimary
        v.numberOfLines = .zero
        return v
    }()
    
    private let emailLabel: UILabel = {
        let v = UILabel()
        v.text = "Email"
        v.font = UIFont.plusJakartaSansMedium16
        v.textColor = .lightBlueSecondinary
        return v
    }()
    
    lazy var emailTextField: CustomTextField = {
        let v = CustomTextField()
        v.placeholder = "Enter Your Email"
        v.isSecureTextEntry = false
        v.showPasswordToggleButton(show: false)
        v.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return v
    }()
    
    private lazy var sendButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("Send", for: .normal)
        v.titleLabel?.font = UIFont.plusJakartaSansSemiBold16
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .defaultBlue
        v.layer.cornerRadius = 8
        v.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        return v
    }()
    
    private let topStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 6
        return v
    }()
    
    private let emailStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 12
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        startObserveKeyboard { _ in }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        authManager.view = self
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [topStackView, emailStackView, sendButton].forEach { v in
            view.addSubview(v)
        }
        
        [topLabel, topTitleLabel].forEach { v in
            topStackView.addArrangedSubview(v)
        }
        
        [emailLabel, emailTextField].forEach { v in
            emailStackView.addArrangedSubview(v)
        }
        
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        emailStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(45)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(24)
            self.targetConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).inset(60).constraint

        }
    }
    
    @objc
    private func didTapSendButton() {
        authManager.sendPasswordReset(email: emailTextField.text ?? "")
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange() {
        emailTextField.setError(nil)
    }
}
