//
//  WishDetailVC.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import WishKitShared

final class DetailWishVC: UIViewController {

    private let cardView = ContainerView()

    private let wishResponse: WishResponse

    private let wishTitleLabel = UILabel()

    private let wishDescriptionLabel = UILabel()

    private let voteButton = VoteButton()

    init(wishResponse: WishResponse) {
        self.wishResponse = wishResponse
        super.init(nibName: nil, bundle: nil)

        self.wishTitleLabel.text = wishResponse.title
        self.wishDescriptionLabel.text = wishResponse.description
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Dark Mode

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard
            let previousTraitCollection = previousTraitCollection
        else {
            return
        }

        if let color = WishKit.theme.secondaryColor {
            // Needed this case where it's the same, there's a weird behaviour otherwise.
            if traitCollection.userInterfaceStyle == previousTraitCollection.userInterfaceStyle {
                if previousTraitCollection.userInterfaceStyle == .light {
                    cardView.backgroundColor = UIColor(color.light)
                }

                if previousTraitCollection.userInterfaceStyle == .dark {
                    cardView.backgroundColor = UIColor(color.dark)
                }
            } else {
                if previousTraitCollection.userInterfaceStyle == .light {
                    cardView.backgroundColor = UIColor(color.dark)
                }

                if previousTraitCollection.userInterfaceStyle == .dark {
                    cardView.backgroundColor = UIColor(color.light)
                }
            }
        }

        if let color = WishKit.theme.tertiaryColor {
            // Needed this case where it's the same, there's a weird behaviour otherwise.
            if traitCollection.userInterfaceStyle == previousTraitCollection.userInterfaceStyle {
                if previousTraitCollection.userInterfaceStyle == .light {
                    view.backgroundColor = UIColor(color.light)
                }

                if previousTraitCollection.userInterfaceStyle == .dark {
                    view.backgroundColor = UIColor(color.dark)
                }
            } else {
                if previousTraitCollection.userInterfaceStyle == .light {
                    view.backgroundColor = UIColor(color.dark)
                }

                if previousTraitCollection.userInterfaceStyle == .dark {
                    view.backgroundColor = UIColor(color.light)
                }
            }
        }
    }

    // MARK: - Setup View

    private func setupView() {
        if let color = WishKit.theme.tertiaryColor {
            if traitCollection.userInterfaceStyle == .light {
                view.backgroundColor = UIColor(color.light)
            }

            if traitCollection.userInterfaceStyle == .dark {
                view.backgroundColor = UIColor(color.dark)
            }
        } else {
            view.backgroundColor = .secondarySystemBackground
        }

        setupNavigation()
        setupCardView()
        setupWishTitleLabel()
        setupWishDescriptionLabel()
        setupVoteButton()
    }

    private func setupNavigation() {
        navigationItem.title = WishKit.config.localization.detail
    }

    private func setupCardView() {
        view.addSubview(cardView)

        cardView.anchor(
            top: view.layoutMarginsGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: UIEdgeInsets(top: 30, left: 15, bottom: 0, right: 15)
        )

        if let color = WishKit.theme.secondaryColor {
            if traitCollection.userInterfaceStyle == .light {
                cardView.backgroundColor = UIColor(color.light)
            }

            if traitCollection.userInterfaceStyle == .dark {
                cardView.backgroundColor = UIColor(color.dark)
            }
        } else {
            cardView.backgroundColor = .tertiarySystemBackground
        }
    }

    private func setupWishTitleLabel() {
        cardView.addSubview(wishTitleLabel)

        wishTitleLabel.anchor(
            top: cardView.topAnchor,
            leading: cardView.leadingAnchor,
            trailing: cardView.trailingAnchor,
            padding: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        )

        wishTitleLabel.numberOfLines = 0
        wishTitleLabel.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
    }

    private func setupWishDescriptionLabel() {
        cardView.addSubview(wishDescriptionLabel)

        wishDescriptionLabel.anchor(
            top: wishTitleLabel.bottomAnchor,
            leading: cardView.leadingAnchor,
            bottom: cardView.bottomAnchor,
            trailing: cardView.trailingAnchor,
            padding: UIEdgeInsets(top: 5, left: 15, bottom: 15, right: 15)
        )

        wishDescriptionLabel.numberOfLines = 0
        wishDescriptionLabel.font = .systemFont(ofSize: 13)
    }

    private func setupVoteButton() {
        view.addSubview(voteButton)

        voteButton.anchor(
            top: cardView.bottomAnchor,
            centerX: view.layoutMarginsGuide.centerXAnchor,
            padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            size: CGSize(width: 200, height: 0)
        )

        voteButton.addTarget(self, action: #selector(voteAction), for: .touchUpInside)
        voteButton.voteCountLabel.text = String(describing: wishResponse.votingUsers.count)
    }

    // MARK: - Logic

    private func handleVoteSuccess(response: VoteWishResponse) {
        voteButton.voteCountLabel.text = String(describing: response.votingUsers.count)
    }

    private func handleVoteError(error: ApiError) {
        AlertManager.confirmMessage(on: self, message: error.reason.description)
    }

    // MARK: - Action

    @objc private func voteAction() {

        // Check if it'syour own wish.
        if wishResponse.userUUID == UUIDManager.getUUID() {
            AlertManager.confirmMessage(on: self, message: WishKit.config.localization.youCanNotVoteForYourOwnWish)
            return
        }

        // Check if you already voted.
        if wishResponse.votingUsers.contains(where: {$0.uuid == UUIDManager.getUUID() }) {
            AlertManager.confirmMessage(on: self, message: WishKit.config.localization.youCanOnlyVoteOnce)
            return
        }

        let voteRequest = VoteWishRequest(wishId: wishResponse.id)

        WishApi.voteWish(voteRequest: voteRequest) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let wishResponse):
                    self.handleVoteSuccess(response: wishResponse)
                case .failure(let error):
                    self.handleVoteError(error: error)
                }
            }
        }
    }
}
#endif
