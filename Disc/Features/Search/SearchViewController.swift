//
//  SearchViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit
import SnapKit
import Lottie

enum SearchSection: Int, CaseIterable {
    case music
    case podcast
    
    var title: String {
        switch self {
        case .music: return "search_music_title".localized()
        case .podcast: return "search_podcast_title".localized()
        }
    }
}

nonisolated enum SearchItem: Hashable {
    case music(MusicTableViewCell.Item)
    case podcast(PodcastTableViewCell.Item)
}

typealias SearchDataSource = UITableViewDiffableDataSource<SearchSection, SearchItem>
typealias SearchSnapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>

final class SearchViewController: UIViewController, Keyboardable {
    
    var targetConstraint: Constraint? = nil
    
    private let viewModel: SearchViewModel
    private var dataSource: SearchDataSource?
    
    private let screenNameLabel: UILabel = {
        let v = UILabel()
        v.text = "search_title".localized()
        v.font = .plusJakartaSansSemiBold20
        v.textAlignment = .left
        v.numberOfLines = .zero
        return v
    }()
    
    private lazy var searchBar: UISearchBar = {
        let v = UISearchBar()
        v.placeholder = "search_placeholder".localized()
        v.returnKeyType = .search
        v.autocapitalizationType = .none
        v.searchBarStyle = .minimal
        v.delegate = self
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .grouped)
        v.backgroundColor = .screenBackground
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.separatorStyle = .none
        v.isHidden = true
        v.delegate = self
        v.dataSource = dataSource
        v.register(MusicTableViewCell.self, forCellReuseIdentifier: MusicTableViewCell.identifier)
        v.register(PodcastTableViewCell.self, forCellReuseIdentifier: PodcastTableViewCell.identifier)
        return v
    }()
    
    private let lottieView: LottieAnimationView = {
        let v = LottieAnimationView(name: "walkingCycle")
        v.contentMode = .scaleAspectFit
        v.loopMode = .loop
        return v
    }()
    
    private let noDataLottieView: LottieAnimationView = {
        let v = LottieAnimationView(name: "nonDataFound")
        v.contentMode = .scaleAspectFit
        v.loopMode = .loop
        v.isHidden = true
        return v
    }()
    
    private let loadingLottieView: LottieAnimationView = {
        let v = LottieAnimationView(name: "ınsideLoading")
        v.contentMode = .scaleAspectFit
        v.loopMode = .loop
        v.isHidden = true
        return v
    }()
    
    init(viewModel: SearchViewModel) {
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
        startObserveKeyboard { _ in }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            self?.didChangeLanguage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        didChangeLanguage()
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        
        [screenNameLabel, searchBar, tableView, lottieView, noDataLottieView, loadingLottieView].forEach { v in
            view.addSubview(v)
        }
        
        screenNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(screenNameLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        lottieView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(40)
            make.size.equalTo(220)
        }
        
        noDataLottieView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(40)
            make.size.equalTo(220)
        }
        
        loadingLottieView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(40)
            make.size.equalTo(220)
        }
    }
    
    private func createDiffableDataSource() {
        dataSource = SearchDataSource(tableView: tableView) { tableView, indexPath, item in
            switch item {
            case .music(let musicItem):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.identifier, for: indexPath) as? MusicTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(item: musicItem)
                return cell
                
            case .podcast(let podcastItem):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PodcastTableViewCell.identifier, for: indexPath) as? PodcastTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(item: podcastItem)
                return cell
            }
        }
    }
    
    private func applySnapshot() {
        var snapshot = SearchSnapshot()
        
        snapshot.appendSections(SearchSection.allCases)
        
        let musicItems = viewModel.musicItems.map { SearchItem.music($0) }
        let podcastItems = viewModel.podcastItems.map { SearchItem.podcast($0) }
        
        snapshot.appendItems(musicItems, toSection: .music)
        snapshot.appendItems(podcastItems, toSection: .podcast)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        Task {
            await viewModel.search(text: searchBar.text ?? "")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.resetState()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let snapshot = dataSource?.snapshot(),
                snapshot.numberOfItems(inSection: snapshot.sectionIdentifiers[section]) > 0 else { return nil }
        
        let label = UILabel()
        label.text = snapshot.sectionIdentifiers[section].title
        label.font = .plusJakartaSansSemiBold16
        label.textColor = .black
        
        let headerView = UIView()
        headerView.backgroundColor = .screenBackground
        headerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let snapshot = dataSource?.snapshot(),
            snapshot.numberOfItems(inSection: snapshot.sectionIdentifiers[section]) > 0 else { return 0 }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .music(let musicItem):
            viewModel.didTapMusic(item: musicItem)
        case .podcast(let podcastItem):
            guard let collectionId = podcastItem.collectionId else { return }
            viewModel.didTapEpisode(collectionId: collectionId)
        }
    }
}

@MainActor
extension SearchViewController: SearchViewModelDelegate {
    
    func reloadTableView() {
        tableView.isHidden = false
        lottieView.isHidden = true
        noDataLottieView.isHidden = true
        loadingLottieView.isHidden = true
        
        applySnapshot()
        
        if !viewModel.musicItems.isEmpty || !viewModel.podcastItems.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func showNoData() {
        tableView.isHidden = true
        lottieView.isHidden = true
        noDataLottieView.isHidden = false
        loadingLottieView.isHidden = true
        noDataLottieView.play()
    }
    
    func showInitialState() {
        tableView.isHidden = true
        lottieView.isHidden = false
        noDataLottieView.isHidden = true
        loadingLottieView.isHidden = true
        lottieView.play()
    }
    
    func showLoading() {
        tableView.isHidden = true
        lottieView.isHidden = true
        noDataLottieView.isHidden = true
        loadingLottieView.isHidden = false
        loadingLottieView.play()
    }
}

extension SearchViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        screenNameLabel.text = "search_title".localized()
        searchBar.placeholder = "search_placeholder".localized()
        applySnapshot()
    }
}
