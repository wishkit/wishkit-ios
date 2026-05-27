import SwiftUI

extension View {
    func fullWidthListSeparator() -> some View {
        self
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            .alignmentGuide(.listRowSeparatorTrailing) { dimensions in dimensions.width }
    }
}
