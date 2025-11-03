//
//  FavoriteViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit
import SnapKit
import Lottie

nonisolated enum FavoriteSection {
    case main
}

typealias FavoriteDataSource = UITableViewDiffableDataSource<FavoriteSection, FavoriteTableViewCell.Item>
typealias FavoriteSnapshot = NSDiffableDataSourceSnapshot<FavoriteSection, FavoriteTableViewCell.Item>

final class FavoriteViewController: UIViewController {
    
    private let viewModel: FavoriteViewModel
    private var dataSource: FavoriteDataSource?
    
    private let screenNameLabel: UILabel = {
        let v = UILabel()
        v.text = "collection_title".localized()
        v.font = .plusJakartaSansSemiBold20
        v.textAlignment = .left
        v.numberOfLines = .zero
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.backgroundColor = .screenBackground
        v.separatorStyle = .none
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.isScrollEnabled = false
        v.dataSource = dataSource
        v.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        return v
    }()
    
    private let lottieView: LottieAnimationView = {
        let v = LottieAnimationView(name: "dinoDance")
        v.contentMode = .scaleAspectFit
        v.loopMode = .loop
        return v
    }()
    
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDiffableDataSource()
        applySnapshot()
        setupUI()
        lottieView.play()
        lottieView.loopMode = .loop
        
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
        [screenNameLabel, tableView, lottieView].forEach { v in
            view.addSubview(v)
        }
        
        screenNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(screenNameLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(220)
        }
        
        lottieView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(220)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func createDiffableDataSource() {
        dataSource = FavoriteDataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(item: item)
            cell.delegate = self
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = FavoriteSnapshot()
        snapshot.appendSections([.main])
        let item = FavoriteTableViewCell.Item(likedList: viewModel.favoriteList)
        snapshot.appendItems([item], toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension FavoriteViewController: FavoriteTableViewCellDelegate {
    func didSelectFavoriteItem(item: FavoriteCollectionViewCell.Item) {
        viewModel.didSelectFavoriteItem(item: item)
    }
}

extension FavoriteViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        screenNameLabel.text = "collection_title".localized()
        applySnapshot()
    }
}
