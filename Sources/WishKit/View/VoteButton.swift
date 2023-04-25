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

    private let upvoteLabel = UILabel(WishKit.config.localization.upvote.uppercased())

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
        let image = UIImage(systemName: "arrowtriangle.up.fill")?.withConfiguration(config).withRenderingMode(.alwaysTemplate)
        arrowIV.image = image
        arrowIV.tintColor = .white

        arrowIV.anchor(
            leading: container.leadingAnchor,
            trailing: container.trailingAnchor,
            centerY: container.centerYAnchor
        )
    }

    private func setupUpVoteLabel() {
        stackView.addArrangedSubview(upvoteLabel)
        upvoteLabel.textColor = .white
    }

    private func setupVoteCountLabel() {
        stackView.addArrangedSubview(voteCountLabel)
        voteCountLabel.textColor = .white
        voteCountLabel.adjustsFontSizeToFitWidth = true
    }
}
#endif
