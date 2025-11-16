//
//  ProfileViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit
import SnapKit

nonisolated enum ProfileSection {
    case main
}

typealias ProfileDataSource = UITableViewDiffableDataSource<ProfileSection, ProfileCellType>
typealias ProfileSnapshot = NSDiffableDataSourceSnapshot<ProfileSection, ProfileCellType>

final class ProfileViewController: UIViewController {
        
    private var viewModel: ProfileViewModel
    private var dataSource: ProfileDataSource?
    
    private let authManager = FirebaseAuthManagerImpl()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.backgroundColor = .screenBackground
        v.separatorStyle = .none
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.delegate = self
        v.dataSource = dataSource
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
        createDiffableDataSource()
        setupUI()
        viewModel.delegate = self
        DIContainer.shared.languageManager.addLanguageChangeListener { [weak self] in
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.width.equalTo(180)
            make.height.equalTo(44)
        }
    }
    
    private func createDiffableDataSource() {
        dataSource = ProfileDataSource(tableView: tableView) { tableView, indexPath, item in
            switch item {
            case .profileDetail(let model):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailTableViewCell.identifier, for: indexPath) as? AccountDetailTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(item: model)
                return cell
                
            case .settingsDetail(let model):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(item: model)
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    private func applySnapshot() {
        var snapshot = ProfileSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.cellTypes, toSection: .main) 
        dataSource?.apply(snapshot, animatingDifferences: false)
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

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .settingsDetail(let settingsItem):
            switch settingsItem.type {
            case .account:
                viewModel.didTapAccount()
            case .language:
                viewModel.didTapLanguage()
            case .about:
                viewModel.didTapAbout()
            case .termsAndConditions:
                viewModel.didTapTerms()
            }
        case .profileDetail:
            break
        }
    }
}

extension ProfileViewController: ProfileViewModelDelegate {
    func reloadTableView() {
        applySnapshot()
    }
}

extension ProfileViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        logoutButton.setTitle("profile_logout_button".localized(), for: .normal)
    }
}
