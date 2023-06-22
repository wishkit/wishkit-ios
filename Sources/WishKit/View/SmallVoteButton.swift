//
//  SmallVoteButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit

final class SmallVoteButton: UIButton {

    private let stackView = UIStackView()

    let arrowIV = UIImageView()

    let voteCountLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        setupStackView()
        setupArrowIV()
        setupVoteCountLabel()

        setupTheme()
    }

    // MARK: - Setup Small

    private func setupStackView() {
        addSubview(stackView)

        stackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )

        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
    }

    private func setupArrowIV() {
        let container = UIView()
        stackView.addArrangedSubview(container)

        container.addSubview(arrowIV)
        arrowIV.anchor(centerX: centerXAnchor, size: CGSize(width: 20, height: 20))
        arrowIV.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
        arrowIV.image = UIImage(systemName: "arrowtriangle.up.fill")
        arrowIV.contentMode = .scaleAspectFit
        arrowIV.tintColor = .tertiaryLabel
    }

    private func setupVoteCountLabel() {
        let container = UIView()
        stackView.addArrangedSubview(container)

        container.addSubview(voteCountLabel)
        voteCountLabel.anchor(
            top: arrowIV.bottomAnchor,
            leading: container.leadingAnchor,
            trailing: container.trailingAnchor,
            padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        )

        voteCountLabel.textAlignment = .center
    }
}

// MARK: - Theme

extension SmallVoteButton {

    // MARK: - WishKit Color

    private func setupTheme() {
        // VoteCountLabel
        if let color = WishKit.theme.textColor {
            if traitCollection.userInterfaceStyle == .light {
                voteCountLabel.textColor = UIColor(color.light)
            }

            if traitCollection.userInterfaceStyle == .dark {
                voteCountLabel.textColor = UIColor(color.dark)
            }
        }
    }
}

// MARK: - Dark/Light mode

extension SmallVoteButton {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard
            let previousTraitCollection = previousTraitCollection
        else {
            return
        }

        // Title & Description
        if let color = WishKit.theme.textColor {
            // Needed this case where it's the same, there's a weird behaviour otherwise.
            if traitCollection.userInterfaceStyle == previousTraitCollection.userInterfaceStyle {
                if previousTraitCollection.userInterfaceStyle == .light {
                    voteCountLabel.textColor = UIColor(color.light)
                }

                if previousTraitCollection.userInterfaceStyle == .dark {
                    voteCountLabel.textColor = UIColor(color.dark)
                }
            } else {
                if previousTraitCollection.userInterfaceStyle == .light {
                    voteCountLabel.textColor = UIColor(color.dark)
                }

                if previousTraitCollection.userInterfaceStyle == .dark {
                    voteCountLabel.textColor = UIColor(color.light)
                }
            }
        }
    }
}
#endif
