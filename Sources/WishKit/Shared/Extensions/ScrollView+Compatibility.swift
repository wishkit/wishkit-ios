import SwiftUI

extension ScrollView {
    func refreshableCompat(action: @escaping @Sendable () async -> Void) -> some View {
        if #available(iOS 15, *) {
            return self.refreshable(action: action)
        }

        return self
    }
}
