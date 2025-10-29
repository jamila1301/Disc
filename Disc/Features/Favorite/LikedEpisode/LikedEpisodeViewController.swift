//
//  LikedEpisodeViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 22.10.25.
//

import UIKit
import SnapKit
import Lottie

final class LikedEpisodeViewController: UIViewController {
    
    private let viewModel: LikedEpisodeViewModel
    
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
        v.dataSource = self
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
        setupUI()
        viewModel.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: false)
        showLoading(true)
        Task {
            await viewModel.fetchLikedEpisodes()
            showLoading(false)
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
}

extension LikedEpisodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.likedEpisodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LikedEpisodeTableViewCell.identifier, for: indexPath) as? LikedEpisodeTableViewCell {
            cell.configure(item: viewModel.likedEpisodeList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectEpisode(index: indexPath.row)
    }
}

extension LikedEpisodeViewController: LikedEpisodeViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension LikedEpisodeViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        title = "collection_liked_episodes".localized()
        tableView.reloadData()
    }
}
