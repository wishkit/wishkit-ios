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
#endif
