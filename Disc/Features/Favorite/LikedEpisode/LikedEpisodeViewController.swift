//
//  LikedEpisodeViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 22.10.25.
//

import UIKit
import SnapKit
import Lottie

nonisolated enum LikedEpisodeSection {
    case main
}

typealias LikedEpisodeDataSource = UITableViewDiffableDataSource<LikedEpisodeSection, LikedEpisodeTableViewCell.Item>
typealias LikedEpisodeSnapshot = NSDiffableDataSourceSnapshot<LikedEpisodeSection, LikedEpisodeTableViewCell.Item>

final class LikedEpisodeViewController: UIViewController {
    
    private let viewModel: LikedEpisodeViewModel
    private var dataSource: LikedEpisodeDataSource?
    
    private let loadingLottieView: LottieAnimationView = {
        let v = LottieAnimationView(name: "ınsideLoading")
        v.contentMode = .scaleAspectFit
        v.loopMode = .loop
        v.isHidden = true
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.backgroundColor = .screenBackground
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.separatorStyle = .none
        v.delegate = self
        v.dataSource = dataSource
        v.register(LikedEpisodeTableViewCell.self, forCellReuseIdentifier: LikedEpisodeTableViewCell.identifier)
        return v
    }()
    
    init(viewModel: LikedEpisodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "collection_liked_episodes".localized()
        createDiffableDataSource()
        setupUI()
        viewModel.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: false)
        showLoading(true)
        Task {
            await viewModel.fetchLikedEpisodes()
        }
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            self?.didChangeLanguage()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        
        view.addSubview(tableView)
        view.addSubview(loadingLottieView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(30)
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
        dataSource = LikedEpisodeDataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikedEpisodeTableViewCell.identifier, for: indexPath) as? LikedEpisodeTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(item: item)
            return cell
        }
    }
    
    private func applySnapshot(items: [LikedEpisodeTableViewCell.Item]) {
        var snapshot = LikedEpisodeSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension LikedEpisodeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        if let index = viewModel.likedEpisodeList.firstIndex(where: { $0.episodeName == item.episodeName && $0.artistName == item.artistName }) {
            viewModel.didSelectEpisode(index: index)
        }
    }
}

extension LikedEpisodeViewController: LikedEpisodeViewModelDelegate {
    func reloadTableView() {
        showLoading(false)
        applySnapshot(items: viewModel.likedEpisodeList)
    }
}

extension LikedEpisodeViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        title = "collection_liked_episodes".localized()
    }
}
