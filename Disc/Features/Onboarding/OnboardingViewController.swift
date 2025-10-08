//
//  OnboardingViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 02.10.25.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    
    private let viewModel: OnboardingViewModel
    
    private let mainImageView: UIImageView = {
        let v = UIImageView()
        v.image = .onboarding
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "Discover Latest Music and Podcast"
        v.numberOfLines = .zero
        v.font = UIFont.plusJakartaSansSemiBold36
        v.textAlignment = .center
        return v
    }()
    
    private let subtitleLabel: UILabel = {
        let v = UILabel()
        v.text = "Listen to the latest music and podcast releases\nusing Disc. app"
        v.numberOfLines = .zero
        v.font = UIFont.plusJakartaSansRegular14
        v.textAlignment = .center
        v.textColor = .lightGrayPrimary
        return v
    }()
    
    private lazy var startButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("Start Exploring", for: .normal)
        v.titleLabel?.font = UIFont.plusJakartaSansSemiBold16
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .defaultBlue
        v.layer.cornerRadius = 8
        v.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return v
    }()
    
    private let labelsStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 16
        v.alignment = .fill
        return v
    }()
    
    private let mainStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 32
        v.alignment = .fill
        return v
    }()
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        
        [titleLabel, subtitleLabel].forEach { v in
            labelsStackView.addArrangedSubview(v)
        }
        
        [mainImageView, labelsStackView].forEach { v in
            mainStackView.addArrangedSubview(v)
        }
        
        [mainStackView, startButton].forEach { v in
            view.addSubview(v)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualTo(startButton.snp.top).offset(-24)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.45)
            make.height.greaterThanOrEqualTo(150)
        }
        
        startButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    @objc
    private func didTapStartButton() {
        viewModel.startExploring()
    }
}

