//
//  Theme.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/18/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public struct Theme {

    public var primaryColor: Color

    public var badgeColor: BadgeTheme

    public init(
        primaryColor: Color,
        badgeColor: BadgeTheme = .default()
    ) {
        self.primaryColor = primaryColor
        self.badgeColor = badgeColor
    }

    public static func `default`() -> Theme {
        return Theme(primaryColor: Theme.systemGreen)
    }

    #if os(macOS)
    private static let systemGreen = Color(NSColor.systemGreen)
    #elseif canImport(UIKit)
    private static let systemGreen = Color(UIColor.systemGreen)
    #endif
}

struct PrivateTheme {
    struct ColorScheme {
        let light: Color
        let dark: Color
    }

    static let systemBackgroundColor = ColorScheme(
        light: Color(red: 242/255, green: 242/255, blue: 247/255),
        dark: Color(red: 28/255, green: 28/255, blue: 30/255)
    )

    static let elementBackgroundColor = ColorScheme(
        light: .white,
        dark: Color(red: 44/255, green: 44/255, blue: 46/255)
    )
}

// MARK: - StatusBadge
#if canImport(UIKit)
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
#else
extension Theme {
    public struct BadgeTheme {
        let pending: Color
        let approved: Color
        let implemented: Color
        let rejected: Color

        public init(pending: Color, approved: Color, implemented: Color, rejected: Color) {
            self.pending = pending
            self.approved = approved
            self.implemented = implemented
            self.rejected = rejected
        }

        public static func `default`() -> BadgeTheme {
            return BadgeTheme(
                pending: .yellow.opacity(0.3),
                approved: .blue.opacity(0.3),
                implemented: .green.opacity(0.3),
                rejected: .red.opacity(0.3)
            )
        }
    }
}
#endif
