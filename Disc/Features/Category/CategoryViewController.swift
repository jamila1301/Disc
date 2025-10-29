//
//  CategoryViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit
import SnapKit

final class CategoryViewController: UIViewController {
    
    private let viewModel: CategoryViewModel
    
    private let screenNameLabel: UILabel = {
        let v = UILabel()
        v.text = "categories_title".localized()
        v.font = .plusJakartaSansSemiBold20
        v.textAlignment = .left
        v.numberOfLines = .zero
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.backgroundColor = .screenBackground
        v.separatorStyle = .none
        v.showsVerticalScrollIndicator = false
        v.dataSource = self
        v.delegate = self
        v.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        return v
    }()
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        
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
        [screenNameLabel, tableView].forEach { v in
            view.addSubview(v)
        }
        
        screenNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(screenNameLabel.snp.bottom).offset(24)
            make.horizontalEdges.bottom.equalToSuperview().inset(24)
        }
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell( withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell {
            cell.configure(item: .init(nameList: viewModel.categories, colors: viewModel.colors))
            cell.onCategorySelected = { [weak self] category in
                guard let self else { return }
                if let index = self.viewModel.categories.firstIndex(where: { $0.categoryName == category }) {
                    self.viewModel.didSelectCategory(index: index)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension CategoryViewController: CategoryViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension CategoryViewController: LocalizeUpdateable {
    func didChangeLanguage() {
        screenNameLabel.text = "categories_title".localized()
        tableView.reloadData()
    }
}
