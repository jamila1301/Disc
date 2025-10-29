//
//  ProfileViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
        
    private var viewModel: ProfileViewModel
    
    private let authManager = FirebaseAuthManagerImpl()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.backgroundColor = .screenBackground
        v.separatorStyle = .none
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.delegate = self
        v.dataSource = self
        v.isScrollEnabled = false
        v.register(AccountDetailTableViewCell.self, forCellReuseIdentifier: AccountDetailTableViewCell.identifier)
        v.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return v
    }()
    
    private lazy var logoutButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("profile_logout_button".localized(), for: .normal)
        v.setTitleColor(.defaultBlue, for: .normal)
        v.titleLabel?.font = .plusJakartaSansBold16
        v.layer.cornerRadius = 22
        v.layer.borderColor = UIColor.defaultBlue.cgColor
        v.layer.borderWidth = 1.5
        v.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        return v
    }()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            self?.didChangeLanguage()
        }
        
        viewModel.startListeningProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.removeListener()
        viewModel.startListeningProfile()
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        
        [tableView, logoutButton].forEach { v in
            view.addSubview(v)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(logoutButton.snp.top).offset(-20)
        }
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
            make.width.equalTo(180)
            make.height.equalTo(44)
        }
    }
    
    @objc private func didTapLogout() {
        Task {
            await authManager.logoutAll()
            DispatchQueue.main.async {
                let vc = LoginBuilder().build()
                let navController = UINavigationController(rootViewController: vc)
                navController.modalPresentationStyle = .fullScreen
                self.view.window?.rootViewController = navController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].type.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section].type[indexPath.row]
        switch section {
        case .profileDetail(let model):
            if let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailTableViewCell.identifier, for: indexPath) as? AccountDetailTableViewCell {
                cell.configure(item: model)
                return cell
            }
            return UITableViewCell()
        case .settingsDetail(let model):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell {
                cell.configure(item: model)
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section].type[indexPath.row]
        switch section {
        case .settingsDetail(let item):
            switch item.type {
            case .account:
                viewModel.didTapAccount()
            case .language:
                viewModel.didTapLanguage()
            case .about:
                viewModel.didTapAbout()
            case .termsAndConditions:
                viewModel.didTapTerms()
            }
        case .profileDetail(_):
            print()
        }
    }
}

extension ProfileViewController: ProfileViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension ProfileViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        logoutButton.setTitle("profile_logout_button".localized(), for: .normal)
        tableView.reloadData()
    }
}
