//
//  WishListVC.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import WishKitShared

final class WishListVC: UIViewController {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()

    private let doneContainer = UIView()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(WishKit.config.localization.done, for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        button.layer.opacity = 0
        return button
    }()

    private let switchContainer = UIView()

    private lazy var switchListControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Kind.requested.title, Kind.implemented.title])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = UIColor(WishKit.theme.primaryColor)
        control.addTarget(self, action: #selector(switchListAction), for: .valueChanged)
        return control
    }()

    private let watermarkLabel: UILabel = {
        let label = UILabel()
        label.text = "\(WishKit.config.localization.poweredBy) Wishkit.io"
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var tableView: TableView = {
        let tableView = TableView()
        tableView.register(WishCell.self, forCellReuseIdentifier: WishCell.identifier)
        tableView.dataSource = wishVM
        tableView.delegate = wishVM
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 80, right: 0)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchWishList), for: .valueChanged)
        return refreshControl
    }()

    private lazy var addWishButton: AddButton = {
        let buttons = AddButton()
        buttons.addTarget(self, action: #selector(createWishAction), for: .touchUpInside)
        return buttons
    }()

    private let spinner = UIActivityIndicatorView()

    private lazy var wishVM: WishListVM = {
        let wishVM = WishListVM()
        wishVM.delegate = self
        return wishVM
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        applyWishKitConfig()

        setup()
        spinner.startAnimating()
        fetchWishList()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateDoneButton()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard
            let color = WishKit.theme.tertiaryColor,
            let previousTraitCollection = previousTraitCollection
        else {
            view.backgroundColor = .secondarySystemBackground
            return
        }

        let segmentedControlActive = WishKit.config.buttons.segmentedControl.activeTextColor
        let segmentedControlDefault = WishKit.config.buttons.segmentedControl.defaultTextColor

        // Needed this case where it's the same, there's a weird behaviour otherwise.
        if traitCollection.userInterfaceStyle == previousTraitCollection.userInterfaceStyle {
            if previousTraitCollection.userInterfaceStyle == .light {
                view.backgroundColor = UIColor(color.light)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlDefault.light)], for: .normal)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlActive.light)], for: .selected)
            } else if previousTraitCollection.userInterfaceStyle == .dark {
                view.backgroundColor = UIColor(color.dark)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlDefault.dark)], for: .normal)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlActive.dark)], for: .selected)
            }
        } else {
            if previousTraitCollection.userInterfaceStyle == .dark {
                view.backgroundColor = UIColor(color.light)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlDefault.light)], for: .normal)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlActive.light)], for: .selected)
            } else if previousTraitCollection.userInterfaceStyle == .light {
                view.backgroundColor = UIColor(color.dark)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlDefault.dark)], for: .normal)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlActive.dark)], for: .selected)
            }
        }
    }
}

// MARK: - Action

extension WishListVC {

    @objc func switchListAction(_ sender: UISegmentedControl) {
        guard let kind = Kind(rawValue: sender.selectedSegmentIndex) else {
            printError(self, "Could not get kind when using segmented control.")
            return
        }

        wishVM.updateList(to: kind)
    }

    @objc private func fetchWishList() {
        wishVM.fetchWishList()
    }

    @objc private func createWishAction() {
        let vc = CreateWishVC()
        vc.delegate = self

        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        } else {
            present(vc, animated: true)
        }
    }

    @objc private func dismissAction() {
        dismiss(animated: true)
    }
}

// MARK: - WishKit config

extension WishListVC {
    func applyWishKitConfig() {
        switch WishKit.config.buttons.segmentedControl.display {
        case .show:
            switchContainer.isHidden = false
        case .hide:
            switchContainer.isHidden = true
        }
    }
}

// MARK: - Setup

extension WishListVC {

    private func setup() {
        navigationItem.title = WishKit.config.localization.featureWishlist

        let segmentedControlActive = WishKit.config.buttons.segmentedControl.activeTextColor
        let segmentedControlDefault = WishKit.config.buttons.segmentedControl.defaultTextColor

        if let color = WishKit.theme.tertiaryColor {
            if traitCollection.userInterfaceStyle == .light {
                view.backgroundColor = UIColor(color.light)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlDefault.light)], for: .normal)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlActive.light)], for: .selected)
            }

            if traitCollection.userInterfaceStyle == .dark {
                view.backgroundColor = UIColor(color.dark)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlDefault.dark)], for: .normal)
                switchListControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(segmentedControlActive.dark)], for: .selected)
            }
        } else {
            view.backgroundColor = .secondarySystemBackground
        }

        setupTabBar()

        setupView()
        setupConstraints()
    }

    private func setupTabBar() {
        tabBarItem.image = WishKit.config.tabBar.image
        tabBarItem.selectedImage = WishKit.config.tabBar.selectedImage
        tabBarItem.title = WishKit.config.localization.wishlist
    }

    private func setupView() {
        view.addSubview(watermarkLabel)
        view.addSubview(spinner)
        view.addSubview(stackView)
        view.addSubview(addWishButton)

        doneContainer.addSubview(doneButton)
        view.addSubview(doneContainer)

        switchContainer.addSubview(switchListControl)

        stackView.setCustomSpacing(0, after: doneContainer)
        stackView.addArrangedSubview(switchContainer)
        stackView.addArrangedSubview(tableView)
        tableView.addSubview(refreshControl)
    }

    private func setupConstraints() {
        let topPadding: CGFloat = WishKit.config.buttons.segmentedControl.display == .hide ? 30 : 0

        stackView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: UIEdgeInsets(top: topPadding, left: 0, bottom: 0, right: 0)
        )

        let spacing: CGFloat = WishKit.config.buttons.segmentedControl.display == .hide ? 0 : 10

        doneContainer.anchor(
            top: view.topAnchor,
            trailing: view.trailingAnchor,
            padding: UIEdgeInsets(top: spacing, left: 0, bottom: 0, right: 0),
            size: CGSize(width: 0, height: 35)
        )

        doneButton.anchor(
            top: doneContainer.topAnchor,
            leading: doneContainer.leadingAnchor,
            bottom: doneContainer.bottomAnchor,
            trailing: doneContainer.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 65)
        )

        switchContainer.anchor(size: CGSize(width: 0, height: 50))

        switchListControl.anchor(
            top: switchContainer.topAnchor,
            bottom: switchContainer.bottomAnchor,
            centerX: switchContainer.centerXAnchor,
            padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        )

        watermarkLabel.anchor(
            centerY: addWishButton.centerYAnchor,
            centerX: view.centerXAnchor
        )

        let hasTabBarController = tabBarController != nil
        var bottomPadding: CGFloat = hasTabBarController ? 20 : 0

        switch WishKit.config.buttons.addButton.bottomPadding {
        case .small:
            break
        case .medium:
            bottomPadding = bottomPadding + 5
        case .large:
            bottomPadding = bottomPadding + 15
        }

        addWishButton.anchor(
            bottom: view.layoutMarginsGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 15)
        )

        spinner.anchor(
            centerY: view.centerYAnchor,
            centerX: view.centerXAnchor
        )
    }
}

// MARK: - Landscape

extension WishListVC {

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        updateDoneButton()
    }

    func updateDoneButton() {
        guard let bounds = view.window?.screen.bounds else {
            return
        }

        if bounds.width > bounds.height {
            UIView.animate(withDuration: 1/6) {
                self.doneButton.layer.opacity = 1
            }
        } else {
            UIView.animate(withDuration: 1/6) {
                self.doneButton.layer.opacity = 0
            }
        }
    }
}

// MARK: - WishVMDelegate

extension WishListVC: WishVMDelegate {
    func listWasUpdated() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            self.watermarkLabel.isHidden = !self.wishVM.shouldShowWatermark
        }
    }

    func didSelect(wishResponse: WishResponse) {
        let vc = DetailWishVC(wishResponse: wishResponse)

        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        } else {
            present(vc, animated: true)
        }
    }
}

// MARK: - CreateWishDelegate

extension WishListVC: CreateWishDelegate {
    func newWishWasSuccessfullyCreated() {
        spinner.startAnimating()
        fetchWishList()
    }
}

// MARK: - Enum

extension WishListVC {
    enum Kind: Int {
        case requested = 0
        case implemented = 1

        var title: String {
            switch self {
            case .requested:
                return WishKit.config.localization.requested
            case .implemented:
                return WishKit.config.localization.implemented
            }
        }
    }
}
#endif
