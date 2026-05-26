#if os(iOS)
import SwiftUI

struct WishlistNavigationBarActionsView: View {

    let isDoneButtonVisible: Bool

    let isNavigationBarAddVisible: Bool

    let dismissAction: () -> Void

    let createActionCompletion: () -> Void

    var body: some View {
        HStack {
            if isDoneButtonVisible {
                Button(WishKit.config.localization.done) {
                    dismissAction()
                }
            }

            if isNavigationBarAddVisible {
                NavigationLink(
                    destination: {
                        CreateWishView(createActionCompletion: createActionCompletion)
                    }, label: {
                        Text(WishKit.config.localization.addButtonInNavigationBar)
                    }
                )
            }
        }
    }
}
#endif
