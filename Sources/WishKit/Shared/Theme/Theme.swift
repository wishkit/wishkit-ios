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
        primaryColor: Color = Theme.defaultPrimaryColor,
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

    // On iOS/macOS/visionOS, .accentColor inherits the host app's accent (typically system blue by default).
    // On watchOS, apps don't have a default accent — Color.accentColor often resolves to a neutral that's
    // visually indistinguishable from gray. So we fall back to an explicit blue there so the SDK looks
    // right out of the box without requiring every consumer to override.
    private static var defaultPrimaryColor: Color {
        #if os(watchOS)
        return .blue
        #else
        return .accentColor
        #endif
    }
}
