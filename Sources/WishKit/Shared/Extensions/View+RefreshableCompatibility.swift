import SwiftUI

extension View {
    @ViewBuilder
    func refreshableCompat(action: @escaping @Sendable () async -> Void) -> some View {
        if #available(iOS 15, *) {
            self.refreshable(action: action)
        } else {
            self
        }
    }
}
