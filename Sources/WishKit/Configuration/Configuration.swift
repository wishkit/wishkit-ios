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
    public var statusBadge: Display

    public var localization: Localization

    public var buttons = Configuration.Buttons()

    public var tabBar = TabBar()

    public var expandDescriptionInList: Bool = false

    public var dropShadow: Display = .show

    public var cornerRadius: CGFloat = 16

    public var emailField: EmailField = .optional

    public var commentSection: Display = .show
    
    public var allowUndoVote: Bool = false

    init(
        statusBadgeDisplay: Display = .hide,
        localization: Localization = .default()
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

// MARK: - Email Field

extension Configuration {
    public enum EmailField {
        case none
        case optional
        case required
    }
}
