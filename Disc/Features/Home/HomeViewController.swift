//
//  HomeViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 05.10.25.
//

import UIKit
import SnapKit
import Lottie

nonisolated enum HomeSection {
    case main
}

typealias HomeDataSource = UITableViewDiffableDataSource<HomeSection, HomeCellType>
typealias HomeSnapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeCellType>

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    private var dataSource: HomeDataSource?
    
    private let appNameLabel: UILabel = {
        let v = UILabel()
        v.text = "Discover"
        v.font = .plusJakartaSansSemiBold20
        v.textAlignment = .left
        v.numberOfLines = .zero
        v.textColor = .black
        return v
    }()
    
    private let lottieView: LottieAnimationView = LottieAnimationView(name: "musicDinosaur")
    
    private let loadingLottieView: LottieAnimationView = {
        let v = LottieAnimationView(name: "ınsideLoading")
        v.contentMode = .scaleAspectFit
        v.loopMode = .loop
        v.isHidden = true
        return v
    }()
    
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
        v.dataSource = dataSource
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
        createDiffableDataSource()
        setupUI()
        lottieView.play()
        lottieView.loopMode = .loop
        showLoading(true)
        Task {
            await viewModel.fetchData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupUI() {
        view.backgroundColor = .screenBackground
        
        [topStackView, tableView, loadingLottieView].forEach { v in
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
        
        loadingLottieView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(220)
        }
    }
    
    private func showLoading(_ show: Bool) {
        loadingLottieView.isHidden = !show
        if show {
            loadingLottieView.play()
        } else {
            loadingLottieView.stop()
        }
    }
    
    private func createDiffableDataSource() {
        dataSource = HomeDataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self else { return UITableViewCell() }
            
            switch item {
            case .banner(let model):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerTableViewCell.identifier, for: indexPath) as? HomeBannerTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(item: model)
                cell.onSelectBanner = { [weak self] selected in
                    Task { await self?.viewModel.playBannerTrack(item: selected) }
                }
                return cell
                
            case .music(let model):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeMusicTableViewCell.identifier, for: indexPath) as? HomeMusicTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(item: model)
                cell.buttonAction = { [weak self] in
                    self?.viewModel.didTapMusic()
                }
                cell.onSelectMusic = { [weak self] selected in
                    Task { await self?.viewModel.playHomeMusic(item: selected) }
                }
                return cell
                
            case .podcast(let model):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomePodcastTableViewCell.identifier, for: indexPath) as? HomePodcastTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(item: model)
                cell.buttonAction = { [weak self] in
                    self?.viewModel.didTapPodcast()
                }
                cell.onSelectPodcast = { [weak self] collectionId in
                    self?.viewModel.didTapEpisode(collectionId: collectionId)
                }
                return cell
            }
        }
    }
    
    private func applySnapshot() {
        var snapshot = HomeSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.cellTypes, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func reloadTableView() {
        showLoading(false)
        applySnapshot()
    }
}
