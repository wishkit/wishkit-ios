//
//  Configuraton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

public struct Configuration {

    /// Hides/Shows the status badge of a wish e.g. "Approved" or "Implemented".
    public var statusBadge: Display

    public var localization: Localizaton

    public var buttons = Configuration.Buttons()

    public var tabBar = TabBar()

    init(
        statusBadgeDisplay: Display = .hide,
        localization: Localizaton = .default()
    ) {
        self.statusBadge = statusBadgeDisplay
        self.localization = localization
    }
}

// MARK: - Display

extension Configuration {
    public enum Display {
        case show
        case hide
    }
}
