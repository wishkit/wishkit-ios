import SwiftUI

extension WishKit {
    /// FeedbackView that renders the list of feedback.
    public struct FeedbackListView: View {

        public init() {}

        public var body: some View {
            #if os(iOS)
                WishlistView(wishModel: WishModel())
            #elseif os(macOS)
                WishlistContainer(wishModel: WishModel())
            #elseif os(visionOS)
                WishlistContainer(wishModel: WishModel())
            #endif
        }
    }
}
