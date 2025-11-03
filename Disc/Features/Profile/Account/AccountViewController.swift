//
//  AccountViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 26.10.25.
//

import UIKit
import SnapKit

final class AccountViewController: UIViewController {
    
    private let viewModel = AccountViewModel()
    
    private let profileImageView: UIImageView = {
        let v = UIImageView()
        v.image = .avatar
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 110
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("profile_add_photo_button".localized(), for: .normal)
        v.titleLabel?.font = .plusJakartaSansBold16
        v.setTitleColor(.white, for: .normal)
        v.layer.cornerRadius = 22
        v.backgroundColor = .defaultBlue
        v.addTarget(self, action: #selector(didTapAddPhotoButton), for: .touchUpInside)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "profile_account_title".localized()
        
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            self?.didChangeLanguage()
        }
        
        connectionViewModel()
        viewModel.startListeningProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.removeListener()
        viewModel.startListeningProfile()
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        [profileImageView, addPhotoButton].forEach { v in
            view.addSubview(v)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(220)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(42)
            make.centerX.equalToSuperview()
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
    }
    
    private func connectionViewModel() {
        viewModel.onProfileImageURLUpdate = { [weak self] urlString in
            guard let self else { return }
            
            if let urlString = urlString {
                self.profileImageView.downloadImage(from: urlString)
            } else {
                self.profileImageView.image = .avatar
            }
        }
        
        viewModel.onError = { errorMessage in
            print(errorMessage)
        }
    }

    
    @objc private func didTapAddPhotoButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }

}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }        
        profileImageView.image = selectedImage
        
        Task {
            await viewModel.uploadProfileImage(selectedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


extension AccountViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        addPhotoButton.setTitle("profile_add_photo_button".localized(), for: .normal)
        title = "profile_account_title".localized()
    }
}
