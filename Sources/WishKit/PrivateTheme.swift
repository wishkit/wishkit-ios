import SwiftUI

struct PrivateTheme {

    struct ColorScheme {
        let light: Color
        let dark: Color
    }

    static let systemBackgroundColor = ColorScheme(
        light: Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255),
        dark: Color(red: 28 / 255, green: 28 / 255, blue: 30 / 255)
    )

    static let elementBackgroundColor = ColorScheme(
        light: .white,
        dark: Color(red: 44 / 255, green: 44 / 255, blue: 46 / 255)
    )
}
