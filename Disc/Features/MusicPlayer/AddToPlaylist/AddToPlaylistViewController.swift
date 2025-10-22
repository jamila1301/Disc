//
//  AddToPlaylistViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 20.10.25.
//

import UIKit
import SnapKit

final class AddToPlaylistViewController: UIViewController {
    
    private let collectionList: [PlaylistTableViewCell.Item] = [
        .init(image: .frame, title: "Liked Musics"),
        .init(image: .frame, title: "Liked Episodes")
    ]
    
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
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "Add to your playlist"
        v.font = .plusJakartaSansSemiBold20
        v.textAlignment = .center
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
        v.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.identifier)
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
        
        [titleLabel, tableView].forEach { v in
            containerView.addSubview(v)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(230)
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

extension AddToPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.identifier, for: indexPath) as? PlaylistTableViewCell {
            cell.configure(item: collectionList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}
