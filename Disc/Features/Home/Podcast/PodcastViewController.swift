//
//  PodcastViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit
import SnapKit
import Lottie

nonisolated enum PodcastSection {
    case main
}

typealias PodcastDataSource = UITableViewDiffableDataSource<PodcastSection, PodcastTableViewCell.Item>
typealias PodcastSnapshot = NSDiffableDataSourceSnapshot<PodcastSection, PodcastTableViewCell.Item>

final class PodcastViewController: UIViewController {
    
    private let viewModel: PodcastViewModel
    private var dataSource: PodcastDataSource?
    
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
        v.register(PodcastTableViewCell.self, forCellReuseIdentifier: PodcastTableViewCell.identifier)
        return v
    }()
    
    init(viewModel: PodcastViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        title = "home_recommended_podcast_title".localized()
        createDiffableDataSource()
        setupUI()
        navigationController?.setNavigationBarHidden(false, animated: false)
        showLoading(true)
        Task {
            await viewModel.fetchData()
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
        dataSource = PodcastDataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PodcastTableViewCell.identifier, for: indexPath) as? PodcastTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(item: item)
            return cell
        }
    }
    
    private func applySnapshot(items: [PodcastTableViewCell.Item]) {
        var snapshot = PodcastSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension PodcastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = dataSource?.itemIdentifier(for: indexPath),
              let collectionId = item.collectionId else { return }
        viewModel.didSelectPodcast(collectionId: collectionId)
    }
}

extension PodcastViewController: PodcastViewModelDelegate {
    func reloadTableView() {
        showLoading(false)
        applySnapshot(items: viewModel.items)
    }
}

extension PodcastViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        title = "home_recommended_podcast_title".localized()
    }
}
