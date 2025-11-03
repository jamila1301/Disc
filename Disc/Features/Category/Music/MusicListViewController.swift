//
//  MusicListViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 16.10.25.
//

import UIKit
import SnapKit
import Lottie

nonisolated enum MusicListSection {
    case main
}

typealias MusicListDataSource = UITableViewDiffableDataSource<MusicListSection, MusicTableViewCell.Item>
typealias MusicListSnapshot = NSDiffableDataSourceSnapshot<MusicListSection, MusicTableViewCell.Item>

final class MusicListViewController: UIViewController {
    
    private let viewModel: MusicListViewModel
    
    private var dataSource: MusicListDataSource?
    
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
        v.separatorStyle = .none
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.delegate = self
        v.dataSource = dataSource
        v.register(MusicTableViewCell.self, forCellReuseIdentifier: MusicTableViewCell.identifier)
        return v
    }()
    
    init(viewModel: MusicListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.category
        viewModel.delegate = self
        createDiffableDataSource()
        setupUI()
        showLoading(true)
        Task {
            await viewModel.fetchData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        dataSource = MusicListDataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.identifier, for: indexPath) as? MusicTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(item: item)
            return cell
        }
        
    }
    
    private func applySnapshot(items: [MusicTableViewCell.Item]) {
        var snapshot = MusicListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension MusicListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = dataSource!.itemIdentifier(for: indexPath) else { return }
        viewModel.didTapMusic(item: item)
    }
}

extension MusicListViewController: MusicListViewModelDelegate {
    func reloadTableView() {
        showLoading(false)
        applySnapshot(items: viewModel.items)
    }
}
