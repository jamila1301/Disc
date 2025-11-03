//
//  LikedMusicViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 22.10.25.
//

import UIKit
import SnapKit
import Lottie

nonisolated enum LikedMusicSection {
    case main
}

typealias LikedMusicDataSource = UITableViewDiffableDataSource<LikedMusicSection, LikedMusicTableViewCell.Item>
typealias LikedMusicSnapshot = NSDiffableDataSourceSnapshot<LikedMusicSection, LikedMusicTableViewCell.Item>

final class LikedMusicViewController: UIViewController {
    
    private let viewModel: LikedMusicViewModel
    private var dataSource: LikedMusicDataSource?
    
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
        v.register(LikedMusicTableViewCell.self, forCellReuseIdentifier: LikedMusicTableViewCell.identifier)
        return v
    }()
    
    init(viewModel: LikedMusicViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "collection_liked_musics".localized()
        createDiffableDataSource()
        setupUI()
        viewModel.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: false)
        showLoading(true)
        Task {
            await viewModel.fetchLikedMusics()
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
        dataSource = LikedMusicDataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikedMusicTableViewCell.identifier, for: indexPath) as? LikedMusicTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(item: item)
            return cell
        }
        tableView.dataSource = dataSource
    }
    
    private func applySnapshot(items: [LikedMusicTableViewCell.Item]) {
        var snapshot = LikedMusicSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension LikedMusicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = dataSource?.itemIdentifier(for: indexPath),
              let index = viewModel.likedMusicList.firstIndex(where: { $0.musicName == item.musicName && $0.artistName == item.artistName }) else {
            return
        }
        viewModel.didSelectMusic(index: index)
    }
}

extension LikedMusicViewController: LikedMusicViewModelDelegate {
    func reloadTableView() {
        showLoading(false)
        applySnapshot(items: viewModel.likedMusicList)
    }
}

extension LikedMusicViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        title = "collection_liked_musics".localized()
    }
}
