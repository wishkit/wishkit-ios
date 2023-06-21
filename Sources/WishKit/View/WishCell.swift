//
//  WishCell.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import WishKitShared

final class WishCell: UITableViewCell {

    static let identifier = "wishcellid"

    private var singleWishResponse: WishResponse?

    private let containerView = ContainerView()

    private let voteButton = SmallVoteButton()

    private let titleBadgeStackView = UIStackView()

    private let stackView = UIStackView()

    private let titleLabel = UILabel(font: .boldSystemFont(ofSize: UIFont.labelFontSize))

    private let badgeContainerView = UIView()

    private let badgeView = BadgeView()

    private let descriptionLabel = UILabel(font: .systemFont(ofSize: 13))

    var delegate: WishCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard
            let color = WishKit.theme.secondaryColor,
            let previousTraitCollection = previousTraitCollection
        else {
            return
        }

        // Needed this case where it's the same, there's a weird behaviour otherwise.
        if traitCollection.userInterfaceStyle == previousTraitCollection.userInterfaceStyle {
            if previousTraitCollection.userInterfaceStyle == .light {
                containerView.backgroundColor = UIColor(color.light)
            }

            if previousTraitCollection.userInterfaceStyle == .dark {
                containerView.backgroundColor = UIColor(color.dark)
            }
        } else {
            if previousTraitCollection.userInterfaceStyle == .light {
                containerView.backgroundColor = UIColor(color.dark)
            }

            if previousTraitCollection.userInterfaceStyle == .dark {
                containerView.backgroundColor = UIColor(color.light)
            }
        }
    }
}

// MARK: - Public

extension WishCell {
    func set(response: WishResponse) {
        self.singleWishResponse = response

        voteButton.voteCountLabel.text = String(describing: response.votingUsers.count)
        titleLabel.text = response.title
        descriptionLabel.text = response.description

        let userUUID = UUIDManager.getUUID()
        if response.userUUID == userUUID || response.votingUsers.contains(where: { $0.uuid == userUUID }) {
            voteButton.arrowIV.tintColor = UIColor(WishKit.theme.primaryColor)
        } else {
            voteButton.arrowIV.tintColor = .tertiaryLabel
        }

        badgeView.configure(with: response.state)

        switch WishKit.config.statusBadge {
        case .show:
            badgeContainerView.isHidden = false
        case .hide:
            badgeContainerView.isHidden = true
        }
    }
}

// MARK: - Setup View

extension WishCell {
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        setupContainerView()
        setupVoteButton()
        setupTitleLabel()
        setupBadgeView()
        setupStackView()
    }

    private func setupContainerView() {
        contentView.addSubview(containerView)

        containerView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
        )

        if let color = WishKit.theme.secondaryColor {
            if traitCollection.userInterfaceStyle == .light {
                containerView.backgroundColor = UIColor(color.light)
            }

            if traitCollection.userInterfaceStyle == .dark {
                containerView.backgroundColor = UIColor(color.dark)
            }
        } else {
            containerView.backgroundColor = .tertiarySystemBackground
        }
    }

    private func setupVoteButton() {
        containerView.addSubview(voteButton)

        voteButton.anchor(
            leading: containerView.leadingAnchor,
            centerY: containerView.centerYAnchor,
            size: CGSize(width: 60, height: 0)
        )

        voteButton.addTarget(self, action: #selector(voteAction), for: .touchUpInside)
    }

    private func setupTitleLabel() {
        titleLabel.textColor = WishKit.config.cell.textColor
        descriptionLabel.textColor = WishKit.config.cell.textColor
        titleBadgeStackView.addArrangedSubview(titleLabel)
    }

    private func setupBadgeView() {
        badgeContainerView.addSubview(badgeView)
        badgeContainerView.anchor(size: CGSize(width: 85, height: 0))

        badgeView.anchor(
            trailing: badgeContainerView.trailingAnchor,
            centerY: badgeContainerView.centerYAnchor
        )

        titleBadgeStackView.addArrangedSubview(badgeContainerView)
    }

    private func setupStackView() {
        containerView.addSubview(stackView)

        stackView.addArrangedSubview(titleBadgeStackView)
        stackView.addArrangedSubview(descriptionLabel)

        stackView.axis = .vertical
        stackView.spacing = 5

        stackView.anchor(
            top: containerView.topAnchor,
            leading: voteButton.trailingAnchor,
            bottom: containerView.bottomAnchor,
            trailing: containerView.trailingAnchor,
            padding: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 15)
        )
    }
}

// MARK: - Action

extension WishCell {
    @objc private func voteAction() {
        guard let response = singleWishResponse else {
            printError(self, "Is missing \(WishResponse.self)")
            return
        }

        var rootViewController = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController

        if #available(iOS 15, *) {
            rootViewController = UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first?
                .rootViewController
        }

        if let rootViewController = rootViewController, response.state == .implemented {
            AlertManager.confirmMessage(on: rootViewController, message: WishKit.config.localization.youCanNotVoteForAnImplementedWish)
            return
        }

        // Check if it's the users own wish.
        if response.userUUID == UUIDManager.getUUID() {
            printWarning(self, WishKit.config.localization.youCanNotVoteForYourOwnWish)

            if let rootViewController = rootViewController {
                AlertManager.confirmMessage(on: rootViewController, message: WishKit.config.localization.youCanNotVoteForYourOwnWish)
            }

            return
        }

        // Check if the user already voted.
        if response.votingUsers.contains(where: { $0.uuid == UUIDManager.getUUID() }) {
            printWarning(self, WishKit.config.localization.youCanOnlyVoteOnce)

            if let rootViewController = rootViewController {
                AlertManager.confirmMessage(on: rootViewController, message: WishKit.config.localization.youCanOnlyVoteOnce)
            }

            return
        }

        let voteRequest = VoteWishRequest(wishId: response.id)

        WishApi.voteWish(voteRequest: voteRequest) { result in
            switch result {
            case .success:
                guard let delegate = self.delegate else {
                    printError(self, "Delegate is missing.")
                    return
                }

                delegate.voteWasTapped()
            case .failure(let error):
                printError(self, error.reason.description)
                DispatchQueue.main.async {
                    if let rootViewController = rootViewController {
                        AlertManager.confirmMessage(on: rootViewController, message: error.reason.description)
                    }
                }
            }
        }

    }
}
#endif
