//
//  HomeViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 05.10.25.
//

import UIKit
import SnapKit
import Lottie

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    
    private let appNameLabel: UILabel = {
        let v = UILabel()
        v.text = "Discover"
        v.font = UIFont.plusJakartaSansSemiBold20
        v.textAlignment = .left
        return v
    }()
    
    private let lottieView: LottieAnimationView = LottieAnimationView(name: "musicDinosaur")
    
    private let topStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.alignment = .center
        v.distribution = .equalSpacing
        v.spacing = 8
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.backgroundColor = .screenBackground
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.separatorStyle = .none
        v.delegate = self
        v.dataSource = self
        v.register(HomeBannerTableViewCell.self, forCellReuseIdentifier: HomeBannerTableViewCell.identifier)
        v.register(HomeMusicTableViewCell.self, forCellReuseIdentifier: HomeMusicTableViewCell.identifier)
        v.register(HomePodcastTableViewCell.self, forCellReuseIdentifier: HomePodcastTableViewCell.identifier)
        return v
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
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
        
        [topStackView, tableView].forEach { v in
            view.addSubview(v)
        }
        
        [appNameLabel, lottieView].forEach { v in
            topStackView.addArrangedSubview(v)
        }
        
        topStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        lottieView.snp.makeConstraints { make in
            make.size.equalTo(55)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.cellTypes[indexPath.row]
        switch cellType {
        case .banner(let model):
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerTableViewCell.identifier, for: indexPath) as? HomeBannerTableViewCell {
                cell.configure(item: model)
                return cell
            }
            return UITableViewCell()
        case .music(let model):
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeMusicTableViewCell.identifier, for: indexPath) as? HomeMusicTableViewCell {
                cell.configure(item: model)
                cell.buttonAction = { [weak self] in
                    self?.viewModel.didTapMusic()
                }
                return cell
            }
            return UITableViewCell()
        case .podcast(let model):
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomePodcastTableViewCell.identifier, for: indexPath) as? HomePodcastTableViewCell {
                cell.configure(item: model)
                cell.buttonAction = { [weak self] in
                    self?.viewModel.didTapPodcast()
                }
                return cell
            }
            return UITableViewCell()
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}
