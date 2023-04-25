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

    /// Hides/Shows the segmented control to switch between 'Requested' and 'Implemented'.
    public var segmentedControl: Display

    public var localization: Localizaton

    public var button = Configuration.Button()

    public var tabBar = TabBar()

    init(
        showStatusBadge: Display = .hide,
        showSegmentedControl: Display = .show,
        button: Configuration.Button = .init(),
        localization: Localizaton = .default()
    ) {
        self.statusBadge = showStatusBadge
        self.segmentedControl = showSegmentedControl
        self.localization = localization
        self.button = button
    }
}

// MARK: - Display

extension Configuration {
    public enum Display {
        case show
        case hide
    }
}
