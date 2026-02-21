import SwiftUI

extension WishKit {
    /// FeedbackView that renders the list of feedback.
    public struct FeedbackListView: View {

        public init() {}

        public var body: some View {
            #if os(macOS) || os(visionOS)
                WishlistContainer(wishModel: WishModel())
            #else
                WishlistViewIOS(wishModel: WishModel())
            #endif
        }
    }
}
