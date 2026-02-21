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

    public var dropShadow: ConfigurationDisplay = .show

    public var cornerRadius: CGFloat = 16

    public var emailField: ConfigurationEmailField = .optional

    public var commentSection: ConfigurationDisplay = .show

    public var allowUndoVote: Bool = false

    init(
        statusBadgeDisplay: ConfigurationDisplay = .hide,
        localization: ConfigurationLocalization = .default()
    ) {
        self.statusBadge = statusBadgeDisplay
        self.localization = localization
    }
}
