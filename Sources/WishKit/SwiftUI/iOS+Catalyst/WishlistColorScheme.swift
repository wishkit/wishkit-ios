//
//  WishlistColorScheme.swift
//  wishkit-ios
//

#if os(iOS)
import SwiftUI

enum WishlistColors {

    static func background(for colorScheme: ColorScheme) -> Color {
        if let color = WishKit.theme.tertiaryColor {
            return color.resolved(for: colorScheme)
        }
        return colorScheme == .dark
            ? PrivateTheme.systemBackgroundColor.dark
            : PrivateTheme.systemBackgroundColor.light
    }

    static func cellBackground(for colorScheme: ColorScheme) -> Color {
        if let color = WishKit.theme.secondaryColor {
            return color.resolved(for: colorScheme)
        }
        return colorScheme == .dark
            ? PrivateTheme.elementBackgroundColor.dark
            : PrivateTheme.elementBackgroundColor.light
    }
}
#endif
