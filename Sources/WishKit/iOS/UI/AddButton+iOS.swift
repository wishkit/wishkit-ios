#if os(iOS)
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
        VStack {
            Image(systemName: "plus")
                .foregroundColor(addButtonTextColor)
        }
        .frame(width: size.width, height: size.height)
        .background(WishKit.theme.primaryColor)
        .clipShape(.circle)
        .shadow(color: .black.opacity(1/4), radius: 3, x: 0, y: 3)
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
#endif
