//
//  Theme.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/18/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

public struct Theme {

    /// This is for the Add-Button, Segmented Control, and Vote-Button.
    public var primaryColor: Color

    /// This is for the background color of cells and text fields.
    public var secondaryColor: Scheme?

    /// This is for the background color of the view/ViewController.
    public var tertiaryColor: Scheme?

    /// The badge that shows the state of a feature.
    public var badgeColor: BadgeTheme

    /// The color of the title and description of a feature.
    public var textColor: Scheme?

    init(
        primaryColor: Color = Theme.systemGreen,
        badgeColor: BadgeTheme = .default(),
        secondaryColor: Scheme? = nil,
        tertiaryColor: Scheme? = nil,
        textColor: Scheme? = nil
    ) {
        self.primaryColor = primaryColor
        self.badgeColor = badgeColor
        self.secondaryColor = secondaryColor
        self.tertiaryColor = tertiaryColor
        self.textColor = textColor
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

extension Theme {
    public struct BadgeTheme {

        @available(*, deprecated, renamed: "inReview")
        public var approved: Scheme

        @available(*, deprecated, renamed: "completed")
        public var implemented: Scheme

        public var pending: Scheme

        public var inReview: Scheme

        public var planned: Scheme

        public var inProgress: Scheme

        public var completed: Scheme

        public var rejected: Scheme

        init(
            approved: Scheme,
            implemented: Scheme,
            pending: Scheme,
            inReview: Scheme,
            planned: Scheme,
            inProgress: Scheme,
            completed: Scheme,
            rejected: Scheme
        ) {
            self.approved = approved
            self.implemented = implemented

            self.pending = pending
            self.inReview = inReview
            self.planned = planned
            self.inProgress = inProgress
            self.completed = completed
            self.rejected = rejected
        }

        static func `default`() -> BadgeTheme {
            return BadgeTheme(
                approved: .setBoth(to: .blue),
                implemented: .setBoth(to: .green),

                pending: .setBoth(to: .yellow),
                inReview: .setBoth(to: Color(red: 1/255, green: 255/255, blue: 255/255)),
                planned: .setBoth(to: .purple),
                inProgress: .setBoth(to: .blue),
                completed: .setBoth(to: .green),
                rejected: .setBoth(to: .red)
            )
        }
    }
}

extension Theme {
    public struct Scheme {
        var light: Color
        var dark: Color

        public init(light: Color, dark: Color) {
            self.light = light
            self.dark = dark
        }

        /// Convenience function to set ligth and dark mode colors.
        static public func `set`(light: Color, dark: Color) -> Scheme {
            return Scheme(light: light, dark: dark)
        }

        /// Sets the same color for light and dark mode.
        static public func `setBoth`(to color: Color) -> Scheme {
            return Scheme(light: color, dark: color)
        }
    }
}
