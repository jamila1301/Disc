//
//  LikedMusicViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 22.10.25.
//

import UIKit
import SnapKit
import Lottie

final class LikedMusicViewController: UIViewController {
    
    private let viewModel: LikedMusicViewModel
    
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
        setupUI()
        viewModel.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: false)
        showLoading(true)
        Task {
            await viewModel.fetchLikedMusics()
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

extension LikedMusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.likedMusicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LikedMusicTableViewCell.identifier, for: indexPath) as? LikedMusicTableViewCell {
            cell.configure(item: viewModel.likedMusicList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectMusic(index: indexPath.row)
    }
}

extension LikedMusicViewController: LikedMusicViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension LikedMusicViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        title = "collection_liked_musics".localized()
        tableView.reloadData()
    }
}
