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
    public var secondaryColor: ThemeScheme?

    /// This is for the background color of the view/ViewController.
    public var tertiaryColor: ThemeScheme?

    /// The badge that shows the state of a feature.
    public var badgeColor: ThemeBadgeTheme

    /// The color of the title and description of a feature.
    public var textColor: ThemeScheme?

    init(
        primaryColor: Color = Theme.systemGreen,
        badgeColor: ThemeBadgeTheme = .default(),
        secondaryColor: ThemeScheme? = nil,
        tertiaryColor: ThemeScheme? = nil,
        textColor: ThemeScheme? = nil
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
