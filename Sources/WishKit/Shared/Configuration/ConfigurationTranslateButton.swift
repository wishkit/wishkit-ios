//
//  ConfigurationTranslateButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 7/28/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

/// Controls the "See translation" affordance on feedback whose language
/// differs from the app's language. Translation runs fully on-device via
/// Apple's Translation framework and requires iOS 18 / macOS 15 or later —
/// on older systems the affordance never shows regardless of this setting.
public enum ConfigurationTranslateButton {

    /// Shows "See translation" only when the detected language of a feedback
    /// differs from the app's language. This is the default.
    case automatic

    /// Always shows "See translation", even when the language appears to match
    /// (covers texts too short for reliable detection).
    case always

    /// Never shows "See translation".
    case hide
}
