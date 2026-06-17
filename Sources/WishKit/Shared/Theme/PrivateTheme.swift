//
//  PrivateTheme.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 5/26/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import SwiftUI

struct PrivateTheme {

    #if canImport(UIKit)
    #if os(watchOS)
    static let systemBackground = Color(uiColor: .lightGray)
    static let elementBackground = Color(uiColor: .lightGray.withAlphaComponent(0.8))
    #elseif os(tvOS)
    // tvOS UIColor doesn't expose semantic background colors — fall back to plain colors.
    // tvOS apps are typically dark, so a black system bg + subtle gray element bg works well.
    static let systemBackground = Color.black
    static let elementBackground = Color.gray.opacity(0.2)
    #else
    static let systemBackground = Color(uiColor: .systemGroupedBackground)
    static let elementBackground = Color(uiColor: .secondarySystemGroupedBackground)
    #endif
    #else
    static let systemBackground = Color(nsColor: .windowBackgroundColor)
    static let elementBackground = Color(nsColor: .controlBackgroundColor)
    #endif
}
