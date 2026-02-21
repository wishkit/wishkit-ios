import SwiftUI

extension Button {

    @ViewBuilder
    func listRowSeparatorCompat(_ visibility: CompatibilityVisibility) -> some View {
        if #available(macOS 13.0, iOS 15, visionOS 1, *) {
            switch visibility {
            case .automatic:
                self.listRowSeparator(.automatic)
            case .visible:
                self.listRowSeparator(.visible)
            case .hidden:
                self.listRowSeparator(.hidden)
            }
        } else {
            self
        }
    }
}
