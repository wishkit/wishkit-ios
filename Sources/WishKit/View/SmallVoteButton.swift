//
//  SmallVoteButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit

final class SmallVoteButton: UIButton {

    let stackView = UIStackView()

    let arrowIV = UIImageView()

    let voteCountLabel = UILabel()

    let upvoteLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        setupSmallStackView()
        setupSmallArrowIV()
        setupSmallVoteCountLabel()
    }

    // MARK: - Setup Small

    private func setupSmallStackView() {
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

    private func setupSmallArrowIV() {
        let container = UIView()
        stackView.addArrangedSubview(container)

        container.addSubview(arrowIV)
        arrowIV.anchor(centerX: centerXAnchor, size: CGSize(width: 20, height: 20))
        arrowIV.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
        arrowIV.image = UIImage(systemName: "arrowtriangle.up.fill")
        arrowIV.contentMode = .scaleAspectFit
        arrowIV.tintColor = .tertiaryLabel
    }

    private func setupSmallVoteCountLabel() {
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
