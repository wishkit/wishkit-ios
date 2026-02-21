import SwiftUI

struct RoundButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .white.opacity(0.66) : .white)
            .background(WishKit.theme.primaryColor)
    }
}
