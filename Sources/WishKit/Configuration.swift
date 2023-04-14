//
//  Configuraton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

public struct Configuration {

    public var showStatusBadge: Bool

    /// Enables the control to switch between 'Requested' and 'Implemented'.
    public var showSegmentedControl: Bool

    public var localization: Localizaton

    @available(*, deprecated, message: "Use 'init(showStatusBadge: showSegmentedControl:)' instead.")
    public init(showStatusBadge: Bool) {
        self.showStatusBadge = showStatusBadge
        self.showSegmentedControl = true
        self.localization = .default()
    }

    public init(showStatusBadge: Bool, showSegmentedControl: Bool, localization: Localizaton = .default()) {
        self.showStatusBadge = showStatusBadge
        self.showSegmentedControl = showSegmentedControl
        self.localization = localization
    }

    public static func `default`() -> Configuration {
        return Configuration(
            showStatusBadge: false,
            showSegmentedControl: true,
            localization: .default()
        )
    }
}
