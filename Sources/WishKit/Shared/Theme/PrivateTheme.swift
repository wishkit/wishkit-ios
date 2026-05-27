//
//  PrivateTheme.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import SwiftUI

struct PrivateTheme {

    #if canImport(UIKit)
    static let systemBackgroundColor = PrivateThemeColorScheme(
        light: Color(uiColor: .systemGroupedBackground),
        dark: Color(uiColor: .systemGroupedBackground)
    )

    static let elementBackgroundColor = PrivateThemeColorScheme(
        light: Color(uiColor: .secondarySystemGroupedBackground),
        dark: Color(uiColor: .secondarySystemGroupedBackground)
    )
    #else
    static let systemBackgroundColor = PrivateThemeColorScheme(
        light: Color(nsColor: .windowBackgroundColor),
        dark: Color(nsColor: .windowBackgroundColor)
    )

    static let elementBackgroundColor = PrivateThemeColorScheme(
        light: Color(nsColor: .controlBackgroundColor),
        dark: Color(nsColor: .controlBackgroundColor)
    )
    #endif
}
