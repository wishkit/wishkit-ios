#if os(iOS)
import SwiftUI

struct WishlistFloatingAddButtonView: View {

    let isVisible: Bool

    let isAddButtonShown: Bool

    let addButtonBottomPadding: CGFloat

    let createActionCompletion: () -> Void

    var body: some View {
        if isVisible {
            HStack {
                Spacer()

                VStack(alignment: .trailing) {
                    VStack {
                        Spacer()

                        if isAddButtonShown {
                            NavigationLink(
                                destination: {
                                    CreateWishView(createActionCompletion: createActionCompletion)
                                }, label: {
                                    AddButton(size: CGSize(width: 60, height: 60))
                                }
                            )
                        }
                    }
                    .padding(.bottom, addButtonBottomPadding)
                }
                .padding(.trailing, 20)
            }
            .frame(maxWidth: 700)
        }
    }
}
#endif
