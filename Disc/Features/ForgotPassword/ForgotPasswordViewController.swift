//
//  ForgotPasswordViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 05.10.25.
//

import UIKit
import SnapKit
import Lottie

final class ForgotPasswordViewController: UIViewController, Keyboardable {
    
    private let viewModel: ForgotPasswordViewModel
    
    var targetConstraint: Constraint? = nil
    
    private lazy var loadingBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        v.isHidden = true
        return v
    }()
    
    private let loadingLottieView: LottieAnimationView = {
        let v = LottieAnimationView(name: "ınsideLoading")
        v.contentMode = .scaleAspectFit
        v.loopMode = .loop
        v.isHidden = true
        return v
    }()
    
    private let topLabel: UILabel = {
        let v = UILabel()
        v.text = "forgot_password_title".localized()
        v.font = .plusJakartaSansSemibold24
        v.numberOfLines = .zero
        return v
    }()
    
    private let topTitleLabel: UILabel = {
        let v = UILabel()
        v.text = "forgot_password_subtitle".localized()
        v.font = .plusJakartaSansRegular14
        v.textColor = .lightGrayPrimary
        v.numberOfLines = .zero
        v.numberOfLines = .zero
        return v
    }()
    
    private let emailLabel: UILabel = {
        let v = UILabel()
        v.text = "forgot_password_email_label".localized()
        v.font = .plusJakartaSansMedium16
        v.textColor = .lightBlueSecondinary
        v.numberOfLines = .zero
        return v
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let v = CustomTextField()
        v.placeholder = "forgot_password_email_placeholder".localized()
        v.isSecureTextEntry = false
        v.showPasswordToggleButton(show: false)
        v.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return v
    }()
    
    private lazy var sendButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("forgot_password_send_button".localized(), for: .normal)
        v.titleLabel?.font = .plusJakartaSansSemiBold16
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
    
    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        startObserveKeyboard { _ in }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            self?.didChangeLanguage()
        }
        
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        
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
    
    private func showLoading(_ show: Bool) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        if show {
            if loadingBackgroundView.superview == nil {
                window.addSubview(loadingBackgroundView)
                loadingBackgroundView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                loadingBackgroundView.addSubview(loadingLottieView)
                loadingLottieView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.size.equalTo(220)
                }
            }
            
            loadingBackgroundView.isHidden = false
            loadingLottieView.isHidden = false
            loadingLottieView.play()
        } else {
            loadingBackgroundView.isHidden = true
            loadingLottieView.isHidden = true
            loadingLottieView.stop()
        }
    }
    
    @objc
    private func didTapSendButton() {
        Task {
            showLoading(true)
            let email = emailTextField.text ?? ""
            do {
                try await viewModel.sendPasswordReset(email: email)
                showLoading(false)
            } catch let error as AuthError {
                showLoading(false)
                switch error {
                case .emptyEmail, .invalidEmail, .userNotFound:
                    emailTextField.setError(error.localizedDescription)
                default:
                    print(error.localizedDescription)
                }
            } catch {
                showLoading(false)
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange() {
        emailTextField.setError(nil)
    }
}

extension ForgotPasswordViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        topLabel.text = "forgot_password_title".localized()
        topTitleLabel.text = "forgot_password_subtitle".localized()
        emailLabel.text = "forgot_password_email_label".localized()
        emailTextField.placeholder = "forgot_password_email_placeholder".localized()
        sendButton.setTitle("forgot_password_send_button".localized(), for: .normal)
    }
}
