#if os(macOS)
import SwiftUI

struct AddButton: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @State
    private var showingSheet = false

    private let size: CGSize

    private let buttonAction: () -> ()

    init(size: CGSize = CGSize(width: 45, height: 45), buttonAction: (() -> ())? = nil) {
        self.size = size
        self.buttonAction = buttonAction ?? { }
    }

    var body: some View {
        Button(action: buttonAction) {
            Image(systemName: "plus")
                .frame(width: size.width, height: size.height)
                .foregroundColor(addButtonTextColor)
                .background(WishKit.theme.primaryColor)
                .clipShape(.circle)
        }
        .buttonStyle(.plain)
        .buttonStyle(.roundButtonStyle)
        .frame(width: size.width, height: size.height)
        .background(WishKit.theme.primaryColor)
        .clipShape(.circle)
        .shadow(color: .black.opacity(0.33), radius: 5, x: 0, y: 5)
    }

    var addButtonTextColor: Color {
        switch colorScheme {
        case .light:
            return WishKit.config.buttons.addButton.textColor.light
        case .dark:
            return WishKit.config.buttons.addButton.textColor.dark
        @unknown default:
            return WishKit.config.buttons.addButton.textColor.light
        }
    }
}

extension ButtonStyle where Self == RoundButtonStyle {
    static var roundButtonStyle: RoundButtonStyle {
        RoundButtonStyle()
    }
}
#endif
