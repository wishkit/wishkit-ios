//
//  Configuraton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

public struct Configuration {

    /// Hides/Shows the status badge of a wish e.g. "Approved" or "Implemented".
    public var statusBadge: ConfigurationDisplay

    public var localization: ConfigurationLocalization

    public var buttons = ConfigurationButtons()

    public var tabBar = ConfigurationTabBar()

    public var expandDescriptionInList: Bool = false

    public var cornerRadius: CGFloat = {
        #if !os(visionOS)
        if #available(iOS 26.0, visionOS 26.0, macOS 26.0, *) {
            return 24
        } else {
            return 8
        }
        #else
        return 36
        #endif
    }()

    public var emailField: ConfigurationEmailField = .none

    public var commentSection: ConfigurationDisplay = .show

    public var allowUndoVote: Bool = false

    /// Prints internal debug output (network requests, decode errors, submit failures) to the console.
    /// Off by default so consumer apps stay quiet in production.
    public var showDebugLogs: Bool = false

    init(
        statusBadgeDisplay: ConfigurationDisplay = .hide,
        localization: ConfigurationLocalization = .default()
    ) {
        self.statusBadge = statusBadgeDisplay
        self.localization = localization
    }
}
