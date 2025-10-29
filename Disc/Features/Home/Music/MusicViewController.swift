//
//  MusicViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit
import SnapKit
import Lottie

final class MusicViewController: UIViewController {
    
    private let viewModel: MusicViewModel
    
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
        v.register(MusicTableViewCell.self, forCellReuseIdentifier: MusicTableViewCell.identifier)
        return v
    }()
    
    init(viewModel: MusicViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        title = "home_recommended_music_title".localized()
        setupUI()
        navigationController?.setNavigationBarHidden(false, animated: false)
        showLoading(true)
        Task {
            await viewModel.fetchData()
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

extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.cellTypes[indexPath.row]
        switch cellType {
        case .music(let model):
            if let cell = tableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.identifier, for: indexPath) as? MusicTableViewCell {
                cell.configure(item: model)
                return cell
            }
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = viewModel.cellTypes[indexPath.row]
        
        switch cellType {
        case .music(let item):
            viewModel.didTapMusic(item: item)
        }
    }

}

extension MusicViewController: MusicViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension MusicViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        title = "home_recommended_music_title".localized()
        tableView.reloadData()
    }
}
