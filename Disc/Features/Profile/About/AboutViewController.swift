//
//  AboutViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 26.10.25.
//

import UIKit
import SnapKit

final class AboutViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        return v
    }()
    
    private let contentView = UIView()
    
    private let topLabel: UILabel = {
        let v = UILabel()
        v.text = "profile_about_description".localized()
        v.font = .plusJakartaSansMedium16
        v.numberOfLines = .zero
        return v
    }()
    
    private let mediumLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = .zero
        
        let attributedText = NSMutableAttributedString()
        
        func addWordFont(title: String, body: String) {
            
            let boldPart = NSAttributedString(string: title + " ", attributes: [.font: UIFont.plusJakartaSansBold16!])
            let regularPart = NSAttributedString(string: body + "\n\n", attributes: [.font: UIFont.plusJakartaSansMedium16!])
            
            attributedText.append(boldPart)
            attributedText.append(regularPart)
        }
        
        addWordFont(title: "profile_home".localized(), body: "profile_home_description".localized())
        
        addWordFont(title: "profile_search".localized(), body: "profile_search_description".localized())
        
        addWordFont(title: "profile_categories".localized(), body: "profile_categories_description".localized())
        
        addWordFont(title: "profile_favorites".localized(), body: "profile_favorites_description".localized())
        
        addWordFont(title: "profile_profile".localized(), body: "profile_profile_description".localized())
        
        v.attributedText = attributedText
        return v
    }()
    
    private let bottomLabel: UILabel = {
        let v = UILabel()
        v.text = "profile_mission_description".localized()
        v.font = .plusJakartaSansMedium16
        v.numberOfLines = .zero
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "profile_about_title".localized()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            self?.didChangeLanguage()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [topLabel, mediumLabel, bottomLabel].forEach { v in
            contentView.addSubview(v)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        mediumLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(mediumLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(65)
        }
    }
}

extension AboutViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        topLabel.text = "profile_about_description".localized()
        bottomLabel.text = "profile_mission_description".localized()
        title = "profile_about_title".localized()
    }
}
