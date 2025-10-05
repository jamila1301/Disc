//
//  PasswordResetSuccessViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 05.10.25.
//

import UIKit
import SnapKit

final class PasswordResetSuccessViewController: UIViewController {
    
    private let backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let v = UIVisualEffectView(effect: blurEffect)
        return v
    }()
    
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        return v
    }()
    
    private let emailIconView: UIImageView = {
        let v = UIImageView()
        v.image = .alert
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "Check Your Email"
        v.font = .plusJakartaSansSemibold24
        v.textAlignment = .center
        return v
    }()
    
    private let messageLabel: UILabel = {
        let v = UILabel()
        v.text = "We already a link to your email to reset\nyour password"
        v.font = .plusJakartaSansRegular14
        v.textColor = .lightGrayPrimary
        v.textAlignment = .center
        v.numberOfLines = .zero
        return v
    }()
    
    private let labelsStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 16
        return v
    }()
    
    private let mainStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 32
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        [backgroundView, containerView].forEach { v in
            view.addSubview(v)
        }
        
        [titleLabel, messageLabel].forEach { v in
            labelsStackView.addArrangedSubview(v)
        }
        
        [emailIconView, labelsStackView].forEach { v in
            mainStackView.addArrangedSubview(v)
        }
        
        containerView.addSubview(mainStackView)
        
        emailIconView.snp.makeConstraints { make in
            make.size.equalTo(64)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.horizontalEdges.equalToSuperview().inset(36)
            make.bottom.equalToSuperview().offset(-32)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
    }
    
    @objc
    private func dismissView() {
        self.dismiss(animated: true)
        
    }
}
