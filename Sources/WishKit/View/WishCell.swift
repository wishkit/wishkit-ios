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
        badgeContainerView.isHidden = !WishKit.configuration.showStatusBadge
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

        containerView.backgroundColor = .tertiarySystemBackground
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
            AlertManager.confirmMessage(on: rootViewController, message: "You cannot vote for a wish that is already implemented 😊")
            return
        }

        // Check if it's the users own wish.
        if response.userUUID == UUIDManager.getUUID() {
            printWarning(self, "You cannot vote for your own wish.")

            if let rootViewController = rootViewController {
                AlertManager.confirmMessage(on: rootViewController, message: "You cannot vote for your own wish.")
            }

            return
        }

        // Check if the user already voted.
        if response.votingUsers.contains(where: { $0.uuid == UUIDManager.getUUID() }) {
            printWarning(self, "You can only vote once.")

            if let rootViewController = rootViewController {
                AlertManager.confirmMessage(on: rootViewController, message: "You can only vote once.")
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
