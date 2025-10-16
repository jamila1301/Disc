//
//  SearchViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit
import SnapKit
import Lottie

final class SearchViewController: UIViewController, Keyboardable {
    
    var targetConstraint: Constraint? = nil
    
    private let viewModel: SearchViewModel
    
    private let appNameLabel: UILabel = {
        let v = UILabel()
        v.text = "Search"
        v.font = UIFont.plusJakartaSansSemiBold20
        v.textAlignment = .left
        return v
    }()
    
    private lazy var searchBar: UISearchBar = {
        let v = UISearchBar()
        v.placeholder = "Search artist, music or podcast"
        v.returnKeyType = .search
        v.autocapitalizationType = .none
        v.searchBarStyle = .minimal
        v.delegate = self
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.backgroundColor = .screenBackground
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.separatorStyle = .none
        v.isHidden = true
        v.delegate = self
        v.dataSource = self
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
        setupUI()
        lottieView.play()
        startObserveKeyboard { _ in }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        
        [appNameLabel, searchBar, tableView, lottieView, noDataLottieView].forEach { v in
            view.addSubview(v)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(24)
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SearchViewModel.Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SearchViewModel.Section(rawValue: section) else { return 0 }
        switch sectionType {
        case .music:
            return viewModel.musicItems.count
        case .podcast:
            return viewModel.podcastItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = SearchViewModel.Section(rawValue: section) else { return nil }
        return viewModel.musicItems.isEmpty && viewModel.podcastItems.isEmpty ? nil : sectionType.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = SearchViewModel.Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch sectionType {
        case .music:
            if indexPath.row < viewModel.musicItems.count {
                if let cell = tableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.identifier, for: indexPath) as? MusicTableViewCell {
                    cell.configure(item: viewModel.musicItems[indexPath.row])
                    return cell
                }
            }
        case .podcast:
            if indexPath.row < viewModel.podcastItems.count {
                if let cell = tableView.dequeueReusableCell(withIdentifier: PodcastTableViewCell.identifier, for: indexPath) as? PodcastTableViewCell {
                    cell.configure(item: viewModel.podcastItems[indexPath.row])
                    return cell
                }
            }
        }
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let sectionType = SearchViewModel.Section(rawValue: indexPath.section) else { return }
        
        switch sectionType {
        case .podcast:
            if indexPath.row < viewModel.podcastItems.count {
                let model = viewModel.podcastItems[indexPath.row]
                guard let collectionId = model.collectionId else { return }
                viewModel.didTapEpisode(collectionId: collectionId)
            }
        case .music:
            break
        }
    }
}

@MainActor
extension SearchViewController: SearchViewModelDelegate {
    
    func reloadTableView() {
        tableView.isHidden = false
        lottieView.isHidden = true
        noDataLottieView.isHidden = true
        tableView.reloadData()
        
        if !viewModel.musicItems.isEmpty || !viewModel.podcastItems.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func showNoData() {
        tableView.isHidden = true
        lottieView.isHidden = true
        noDataLottieView.isHidden = false
        noDataLottieView.play()
    }
    
    func showInitialState() {
        tableView.isHidden = true
        lottieView.isHidden = false
        noDataLottieView.isHidden = true
        lottieView.play()
    }
    
    func showLoading() {
        tableView.isHidden = true
        lottieView.isHidden = false
        noDataLottieView.isHidden = true
        lottieView.play()
    }
}
