//
//  LanguageViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 27.10.25.
//

import UIKit
import SnapKit

final class LanguageViewController: UIViewController {
    
    private let languageManager = LanguageManager.shared
    
    private let languageList: [(language: Language, item: LanguageTableViewCell.Item)] = [
        (language: .az, item: .init(image: .AZ, title: "profile_language_azerbaijani".localized())),
        (language: .en, item: .init(image: .GB, title: "profile_language_english".localized())),
        (language: .ru, item: .init(image: .RU, title: "profile_language_russian".localized()))
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
        v.dataSource = self
        v.isScrollEnabled = false
        v.register(LanguageTableViewCell.self, forCellReuseIdentifier: LanguageTableViewCell.identifier)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
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
}

extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LanguageTableViewCell.identifier, for: indexPath) as? LanguageTableViewCell {
            cell.configure(item: languageList[indexPath.row].item)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage = languageList[indexPath.row].language
        languageManager.set(language: selectedLanguage)
        
        dismiss(animated: true)
    }

}

extension LanguageViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        titleLabel.text = "profile_language_title".localized()
        tableView.reloadData()
    }
}
