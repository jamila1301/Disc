//
//  LanguageViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 27.10.25.
//

import UIKit
import SnapKit

nonisolated enum LanguageSection {
    case main
}

typealias LanguageDataSource = UITableViewDiffableDataSource<LanguageSection, LanguageTableViewCell.Item>
typealias LanguageSnapshot = NSDiffableDataSourceSnapshot<LanguageSection, LanguageTableViewCell.Item>

final class LanguageViewController: UIViewController {
    
    private let languageManager = LanguageManager.shared
    private var dataSource: LanguageDataSource?
    
    private let languageItems: [LanguageTableViewCell.Item] = [
        .init(image: .AZ, title: "profile_language_azerbaijani".localized(), language: .az),
        .init(image: .GB, title: "profile_language_english".localized(), language: .en),
        .init(image: .RU, title: "profile_language_russian".localized(), language: .ru)
    ]
    
    private let backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let v = UIVisualEffectView(effect: blurEffect)
        return v
    }()
    
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .defaultBlue
        v.layer.cornerRadius = 24
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "profile_language_title".localized()
        v.font = .plusJakartaSansSemiBold20
        v.textAlignment = .center
        v.textColor = .white
        v.numberOfLines = .zero
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.backgroundColor = .white
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.separatorStyle = .none
        v.delegate = self
        v.dataSource = dataSource
        v.isScrollEnabled = false
        v.register(LanguageTableViewCell.self, forCellReuseIdentifier: LanguageTableViewCell.identifier)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDiffableDataSource()
        setupUI()
        applySnapshot()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tapGesture)
        
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            self?.didChangeLanguage()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        [backgroundView, containerView].forEach { v in
            view.addSubview(v)
        }
        
        [titleLabel, tableView].forEach { v in
            containerView.addSubview(v)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(310)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(containerView.snp.bottom).offset(-20)
        }
        
    }
    
    @objc
    private func dismissView() {
        self.dismiss(animated: true)
        
    }
    
    private func createDiffableDataSource() {
        dataSource = LanguageDataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageTableViewCell.identifier, for: indexPath) as? LanguageTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(item: item)
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = LanguageSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(languageItems, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension LanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = languageItems[indexPath.row]
        languageManager.set(language: selectedItem.language)
        dismiss(animated: true)
    }
}

extension LanguageViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        titleLabel.text = "profile_language_title".localized()
        let updatedItems = [
            LanguageTableViewCell.Item(image: .AZ, title: "profile_language_azerbaijani".localized(), language: .az),
            LanguageTableViewCell.Item(image: .GB, title: "profile_language_english".localized(), language: .en),
            LanguageTableViewCell.Item(image: .RU, title: "profile_language_russian".localized(), language: .ru)
        ]
        
        var snapshot = LanguageSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(updatedItems, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
}
