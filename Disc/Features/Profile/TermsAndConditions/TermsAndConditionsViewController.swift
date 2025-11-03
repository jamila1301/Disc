//
//  TermsAndConditionsViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 27.10.25.
//

import UIKit
import SnapKit

final class TermsAndConditionsViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        return v
    }()
    
    private let contentView = UIView()
    
    private let topLabel: UILabel = {
        let v = UILabel()
        v.text = "profile_terms_intro".localized()
        v.font = .plusJakartaSansSemiBold16
        v.numberOfLines = .zero
        return v
    }()
    
    private let bottomLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = .zero
        
        let attributedText = NSMutableAttributedString()
        
        func addWordFont(title: String, body: String) {
            
            let boldPart = NSAttributedString(string: title + " ", attributes: [.font: UIFont.plusJakartaSansBold16!])
            let regularPart = NSAttributedString(string: body + "\n\n", attributes: [.font: UIFont.plusJakartaSansMedium16!])
            
            attributedText.append(boldPart)
            attributedText.append(regularPart)
        }
        
        addWordFont(title: "profile_terms_content_ownership_header".localized(), body: "profile_terms_content_ownership".localized())
        
        addWordFont(title: "profile_terms_personal_use_header".localized(), body: "profile_terms_personal_use".localized())
        
        addWordFont(title: "profile_terms_account_security_header".localized(), body: "profile_terms_account_security".localized())
        
        addWordFont(title: "profile_terms_app_updates_header".localized(), body: "profile_terms_app_updates".localized())
        
        addWordFont(title: "profile_terms_disclaimer_header".localized(), body: "profile_terms_disclaimer".localized())
        
        addWordFont(title: "profile_terms_liability_header".localized(), body: "profile_terms_liability".localized())
        
        addWordFont(title: "profile_terms_governing_law_header".localized(), body: "profile_terms_governing_law".localized())
        
        v.attributedText = attributedText
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "profile_terms_title".localized()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            self?.didChangeLanguage()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [topLabel, bottomLabel].forEach { v in
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
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

extension TermsAndConditionsViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        topLabel.text = "profile_terms_intro".localized()
        title = "profile_terms_title".localized()
    }
}
