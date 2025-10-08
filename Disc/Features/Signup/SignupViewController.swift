//
//  SignupViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 04.10.25.
//

import UIKit
import SnapKit

final class SignupViewController: UIViewController, Keyboardable {
    
    private let viewModel: SignupViewModel
        
    var targetConstraint: Constraint? = nil
    
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.showsVerticalScrollIndicator = false
        v.delaysContentTouches = false
        v.canCancelContentTouches = true
        return v
    }()
    
    private let contentView = UIView()
    
    private let topLabel: UILabel = {
        let v = UILabel()
        v.text = "Create Account"
        v.font = UIFont.plusJakartaSansSemibold24
        return v
    }()
    
    private let topTitleLabel: UILabel = {
        let v = UILabel()
        v.text = "Please fill in to complete your account"
        v.font = UIFont.plusJakartaSansRegular16
        v.textColor = .lightGrayPrimary
        v.numberOfLines = .zero
        return v
    }()
    
    private let nameLabel: UILabel = {
        let v = UILabel()
        v.text = "Name"
        v.font = UIFont.plusJakartaSansMedium16
        v.textColor = .lightBlueSecondinary
        return v
    }()
    
    private lazy var nameTextField: CustomTextField = {
        let v = CustomTextField()
        v.placeholder = "Enter Your Name"
        v.isSecureTextEntry = false
        v.showPasswordToggleButton(show: false)
        v.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return v
    }()
    
    private let emailLabel: UILabel = {
        let v = UILabel()
        v.text = "Email"
        v.font = UIFont.plusJakartaSansMedium16
        v.textColor = .lightBlueSecondinary
        return v
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let v = CustomTextField()
        v.placeholder = "Enter Your Email"
        v.isSecureTextEntry = false
        v.showPasswordToggleButton(show: false)
        v.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return v
    }()
    
    private let passwordLabel: UILabel = {
        let v = UILabel()
        v.text = "Password"
        v.font = UIFont.plusJakartaSansMedium16
        v.textColor = .lightBlueSecondinary
        return v
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let v = CustomTextField()
        v.placeholder = "Create Password"
        v.isSecureTextEntry = true
        v.showPasswordToggleButton(show: true)
        v.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return v
    }()
    
    private lazy var signUpButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("Sign Up", for: .normal)
        v.titleLabel?.font = UIFont.plusJakartaSansSemiBold16
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .defaultBlue
        v.layer.cornerRadius = 8
        v.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        return v
    }()
    
    private let orContinueLabel: UILabel = {
        let v = UILabel()
        v.text = "Or create account using your social profile"
        v.font = UIFont.plusJakartaSansRegular14
        v.textColor = .lightGrayPrimary
        v.textAlignment = .center
        return v
    }()
    
    private let googleImageView: UIImageView = {
        let v = UIImageView()
        v.image = .google
        return v
    }()
    
    private let facebookImageView: UIImageView = {
        let v = UIImageView()
        v.image = .facebook
        return v
    }()
    
    private let appleImageView: UIImageView = {
        let v = UIImageView()
        v.image = .apple
        return v
    }()
    
    private lazy var googleView: UIView = {
        let v = UIView()
        v.backgroundColor = .buttonView
        v.layer.cornerRadius = 20
        
        v.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(didTapGoogle))
        v.addGestureRecognizer(tapGesture)
        
        return v
    }()
    
    private lazy var facebookView: UIView = {
        let v = UIView()
        v.backgroundColor = .buttonView
        v.layer.cornerRadius = 20
        
        v.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(didTapFacebook))
        v.addGestureRecognizer(tapGesture)
        
        return v
    }()
    
    private lazy var appleView: UIView = {
        let v = UIView()
        v.backgroundColor = .buttonView
        v.layer.cornerRadius = 20
        
        v.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(didTapApple))
        v.addGestureRecognizer(tapGesture)
        
        return v
    }()
    
    private let signInLabel: UILabel = {
        let v = UILabel()
        v.text = "Already have an account?"
        v.font = UIFont.plusJakartaSansRegular14
        v.textColor = .lightGrayPrimary
        return v
    }()
    
    private lazy var signInButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("Sign In", for: .normal)
        v.titleLabel?.font = UIFont.plusJakartaSansMedium14
        v.setTitleColor(.defaultBlue, for: .normal)
        v.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return v
    }()
    
    private let topStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 6
        return v
    }()
    
    private let nameStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 12
        return v
    }()
    
    private let emailStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 12
        return v
    }()
    
    private let passwordStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 12
        return v
    }()
    
    private let middleStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 32
        return v
    }()
    
    private let signInStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 2
        return v
    }()
    
    private let socialStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 17
        v.alignment = .center
        return v
    }()
    
    private let downStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 20
        v.alignment = .center
        return v
    }()
    
    private let bottomStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 32
        return v
    }()
    
    init(viewModel: SignupViewModel) {
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
        scrollView.addGestureRecognizer(tapGesture)
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        [topStackView, middleStackView, bottomStackView].forEach { v in
            contentView.addSubview(v)
        }
        
        [topLabel, topTitleLabel].forEach { v in
            topStackView.addArrangedSubview(v)
        }
        
        [nameLabel, nameTextField].forEach { v in
            nameStackView.addArrangedSubview(v)
        }
        
        [emailLabel, emailTextField].forEach { v in
            emailStackView.addArrangedSubview(v)
        }
        
        [passwordLabel, passwordTextField].forEach { v in
            passwordStackView.addArrangedSubview(v)
        }
        
        [nameStackView, emailStackView, passwordStackView].forEach { v in
            middleStackView.addArrangedSubview(v)
        }
        
        [signInLabel, signInButton].forEach { v in
            signInStackView.addArrangedSubview(v)
        }
        
        googleView.addSubview(googleImageView)
        facebookView.addSubview(facebookImageView)
        appleView.addSubview(appleImageView)
        
        [googleView, facebookView, appleView].forEach { v in
            socialStackView.addArrangedSubview(v)
        }
        
        [orContinueLabel, socialStackView, signInStackView].forEach { v in
            downStackView.addArrangedSubview(v)
        }
        
        [signUpButton, downStackView].forEach { v in
            bottomStackView.addArrangedSubview(v)
        }
        
        googleImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        facebookImageView.snp.makeConstraints { make in
            make.size.equalTo(26)
        }
        
        appleImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
        
        googleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        facebookImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(7)
        }
        
        appleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        
        topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        middleStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(45)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(middleStackView.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview().inset(24)
            self.targetConstraint = make.bottom.equalToSuperview().inset(24).constraint
        }
        
    }
    
    @objc private func textFieldDidChange() {
        nameTextField.setError(nil)
        emailTextField.setError(nil)
        passwordTextField.setError(nil)
    }

    @objc
    private func didTapSignInButton() {
        viewModel.navigateToSignin()
    }
    
    @objc
    private func didTapSignUpButton()  {
        Task {
            let name = nameTextField.text ?? ""
            let email = emailTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            do {
                try await viewModel.signupWithEmail(name: name, email: email, password: password)
            } catch let error as AuthError {
                switch error {
                case .emptyName:
                    nameTextField.setError(error.localizedDescription)
                case .emptyEmail, .invalidEmail, .emailAlreadyInUse:
                    emailTextField.setError(error.localizedDescription)
                case .emptyPassword, .weakPassword:
                    passwordTextField.setError(error.localizedDescription)
                default:
                    print(error.localizedDescription)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    private func didTapGoogle() {
        Task {
            do {
                try await viewModel.loginWithGoogle()
            } catch {
                print("Google signup error: \(error)")
            }
        }
    }
    
    @objc
    private func didTapFacebook() {
        Task {
            do {
                try await viewModel.loginWithFacebook()
            } catch {
                print("Facebook signup error: \(error)")
            }
        }
    }
    
    @objc
    private func didTapApple() {
        Task {
            do {
                try await viewModel.loginWithApple()
            } catch {
                print("Apple signup error: \(error)")
            }
        }
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

