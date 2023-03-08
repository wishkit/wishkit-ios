//
//  BadgeView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit
import WishKitShared

final class BadgeView: UIView {

    let descriptionLabel = UILabel(color: .label.withAlphaComponent(0.8), font: .boldSystemFont(ofSize: 10))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure

extension BadgeView {
    func configure(with wishState: WishState) {
        descriptionLabel.text = wishState.rawValue.uppercased()
        
        switch wishState {
        case .pending:
            backgroundColor = WishKit.theme.badgeColor.pending
        case .approved:
            backgroundColor = WishKit.theme.badgeColor.approved
        case .implemented:
            backgroundColor = WishKit.theme.badgeColor.implemented
        case .rejected:
            backgroundColor = WishKit.theme.badgeColor.rejected
        }
    }
}

// MARK: - Setup

extension BadgeView {

    private func setupView() {
        layer.cornerRadius = 6
        layer.cornerCurve = .continuous
        setupDescriptionLabel()
    }

    private func setupDescriptionLabel() {
        addSubview(descriptionLabel)

        descriptionLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        )
    }
}
