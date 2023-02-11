//
//  WishListVC.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit

final class WishListVC: UIViewController {
    enum Kind: Int {
        case requested = 0
        case implemented = 1

        var title: String {
            switch self {
            case .requested:
                return "Requested"
            case .implemented:
                return "Implemented"
            }
        }
    }

    private lazy var switchListControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Kind.requested.title, Kind.implemented.title])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .systemBlue
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        control.addTarget(self, action: #selector(switchListAction), for: .valueChanged)
        return control
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WishCell.self, forCellReuseIdentifier: WishCell.identifier)
        tableView.dataSource = wishVM
        tableView.delegate = wishVM
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchWishList), for: .valueChanged)
        return refreshControl
    }()

    private lazy var addWishButton: AddButton = {
        let button = AddButton()
        button.addTarget(self, action: #selector(createWishAction), for: .touchUpInside)
        return button
    }()

    private let spinner = UIActivityIndicatorView()

    private lazy var wishVM: WishVM = {
        let wishVM = WishVM()
        wishVM.delegate = self
        return wishVM
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        spinner.startAnimating()
        fetchWishList()
    }
}

// MARK: - Action

extension WishListVC {

    @objc func switchListAction(_ sender: UISegmentedControl) {
        guard let kind = Kind(rawValue: sender.selectedSegmentIndex) else {
            printError(self, "Could not get kind when using segmented control.")
            return
        }

        wishVM.showList(of: kind)
    }

    @objc private func fetchWishList() {
        wishVM.fetchWishList()
    }

    @objc private func createWishAction() {
//        let vc = CreateWishVC()
//        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Setup

extension WishListVC {

    private func setup() {
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "Feature Wishlist"

        setupView()
        setupConstraints()
    }

    private func setupView() {
        view.addSubview(switchListControl)
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        view.addSubview(addWishButton)
        view.addSubview(spinner)
    }

    private func setupConstraints() {
        switchListControl.anchor(
            top: view.topAnchor,
            centerX: view.centerXAnchor,
            padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        )

        tableView.anchor(
            top: switchListControl.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        )

        addWishButton.anchor(
            bottom: view.layoutMarginsGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        )

        spinner.anchor(
            centerY: view.centerYAnchor,
            centerX: view.centerXAnchor
        )
    }
}

// MARK: - WishVMDelegate

extension WishListVC: WishVMDelegate {
    func listWasUpdated() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }

    func didSelect(wishResponse: SingleWishResponse) {
//        let vc = DetailWishVC(wishResponse: wishResponse)
//        navigationController?.pushViewController(vc, animated: true)
    }
}
