//
//  VoteButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/13/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit

final class VoteButton: UIButton {

    private let stackView = UIStackView()

    private let arrowIV = UIImageView()

    let voteCountLabel = UILabel()

    private let upvoteLabel = UILabel(WishKit.config.localization.upvote)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Medium

    private func setupView() {
        backgroundColor = UIColor(WishKit.theme.primaryColor)
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous

        setupStackView()
        setupArrowIV()
        setupUpVoteLabel()
        setupVoteCountLabel()
    }

    private func setupStackView() {
        addSubview(stackView)

        stackView.anchor(
            top: topAnchor, bottom: bottomAnchor,
            centerX: centerXAnchor,
            size: CGSize(width: 0, height: 45)
        )

        stackView.spacing = 10
        stackView.isUserInteractionEnabled = false
    }

    private func setupArrowIV() {
        let container = UIView()
        stackView.addArrangedSubview(container)

        container.addSubview(arrowIV)
        container.anchor(size: CGSize(width: 15, height: 0))

        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14), scale: .medium)
        let image = UIImage(systemName: "arrowtriangle.up.fill")?.withConfiguration(config)
        arrowIV.image = image

        if traitCollection.userInterfaceStyle == .light {
            arrowIV.tintColor = UIColor(WishKit.config.buttons.voteButton.textColor.light)
        }

        if traitCollection.userInterfaceStyle == .dark {
            arrowIV.tintColor = UIColor(WishKit.config.buttons.voteButton.textColor.dark)
        }

        arrowIV.anchor(
            leading: container.leadingAnchor,
            trailing: container.trailingAnchor,
            centerY: container.centerYAnchor
        )
    }

    private func setupUpVoteLabel() {
        stackView.addArrangedSubview(upvoteLabel)
    }

    private func setupVoteCountLabel() {
        stackView.addArrangedSubview(voteCountLabel)
        voteCountLabel.adjustsFontSizeToFitWidth = true
    }
}

// MARK: - Theme

extension VoteButton {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard
            let previousTraitCollection = previousTraitCollection
        else {
            return
        }

        // ContainerView
        let textColor = WishKit.config.buttons.voteButton.textColor
        
        // Needed this case where it's the same, there's a weird behaviour otherwise.
        if traitCollection.userInterfaceStyle == previousTraitCollection.userInterfaceStyle {
            if previousTraitCollection.userInterfaceStyle == .light {
                arrowIV.tintColor = UIColor(textColor.light)
                upvoteLabel.textColor = UIColor(textColor.light)
                voteCountLabel.textColor = UIColor(textColor.light)
            }

            if previousTraitCollection.userInterfaceStyle == .dark {
                arrowIV.tintColor = UIColor(textColor.dark)
                upvoteLabel.textColor = UIColor(textColor.dark)
                voteCountLabel.textColor = UIColor(textColor.dark)
            }
        } else {
            if previousTraitCollection.userInterfaceStyle == .light {
                arrowIV.tintColor = UIColor(textColor.dark)
                upvoteLabel.textColor = UIColor(textColor.dark)
                voteCountLabel.textColor = UIColor(textColor.dark)
            }

            if previousTraitCollection.userInterfaceStyle == .dark {
                arrowIV.tintColor = UIColor(textColor.light)
                upvoteLabel.textColor = UIColor(textColor.light)
                voteCountLabel.textColor = UIColor(textColor.light)
            }
        }
    }
}
#endif
