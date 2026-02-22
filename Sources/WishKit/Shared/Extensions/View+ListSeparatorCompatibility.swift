import SwiftUI

extension View {
    @ViewBuilder
    func fullWidthListSeparatorCompat() -> some View {
        if #available(iOS 16, macOS 13, visionOS 1, *) {
            self
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                .alignmentGuide(.listRowSeparatorTrailing) { dimensions in dimensions.width }
        } else {
            self
        }
    }
}
