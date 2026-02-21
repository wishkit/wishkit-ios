import SwiftUI

public struct ThemeScheme {
    var light: Color
    var dark: Color

    public init(light: Color, dark: Color) {
        self.light = light
        self.dark = dark
    }

    /// Convenience function to set light and dark mode colors.
    public static func `set`(light: Color, dark: Color) -> ThemeScheme {
        ThemeScheme(light: light, dark: dark)
    }

    /// Sets the same color for light and dark mode.
    public static func setBoth(to color: Color) -> ThemeScheme {
        ThemeScheme(light: color, dark: color)
    }
}
