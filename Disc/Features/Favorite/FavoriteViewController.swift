//
//  FavoriteViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit
import SnapKit
import Lottie

final class FavoriteViewController: UIViewController {
    
    private let viewModel: FavoriteViewModel
    
    private let screenNameLabel: UILabel = {
        let v = UILabel()
        v.text = "Collection"
        v.font = .plusJakartaSansSemiBold20
        v.textAlignment = .left
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.backgroundColor = .screenBackground
        v.separatorStyle = .none
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.isScrollEnabled = false
        v.dataSource = self
        v.delegate = self
        v.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        return v
    }()
    
    private let lottieView: LottieAnimationView = {
        let v = LottieAnimationView(name: "dinoDance")
        v.contentMode = .scaleAspectFit
        v.loopMode = .loop
        return v
    }()
    
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        lottieView.play()
        lottieView.loopMode = .loop
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        [screenNameLabel, tableView, lottieView].forEach { v in
            view.addSubview(v)
        }
        
        screenNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(screenNameLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(300)
        }
        
        lottieView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(220)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell( withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell {
            cell.configure(item: .init(likedList: viewModel.favoriteList))
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
}

extension FavoriteViewController: FavoriteTableViewCellDelegate {
    func didSelectFavoriteItem(item: FavoriteCollectionViewCell.Item) {
        viewModel.didSelectFavoriteItem(item: item)
    }
}
