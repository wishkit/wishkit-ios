//
//  Theme.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/18/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit

public struct Theme {

    public var primaryColor: UIColor

    public var badgeColor: BadgeTheme

    public init(
        primaryColor: UIColor,
        badgeColor: BadgeTheme = .default()
    ) {
        self.primaryColor = primaryColor
        self.badgeColor = badgeColor
    }

    public static func `default`() -> Theme {
        return Theme(primaryColor: .systemGreen)
    }
}

// MARK: - StatusBadge

extension Theme {
    public struct BadgeTheme {
        let pending: UIColor
        let approved: UIColor
        let implemented: UIColor
        let rejected: UIColor

        public init(pending: UIColor, approved: UIColor, implemented: UIColor, rejected: UIColor) {
            self.pending = pending
            self.approved = approved
            self.implemented = implemented
            self.rejected = rejected
        }

        public static func `default`() -> BadgeTheme {
            return BadgeTheme(
                pending: .systemYellow.withAlphaComponent(0.3),
                approved: .systemBlue.withAlphaComponent(0.3),
                implemented: .systemGreen.withAlphaComponent(0.3),
                rejected: .systemRed.withAlphaComponent(0.3)
            )
        }
    }
}
