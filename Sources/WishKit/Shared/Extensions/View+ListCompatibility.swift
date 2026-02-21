import SwiftUI

extension View {

    @ViewBuilder
    func scrollContentBackgroundCompat(_ visibility: CompatibilityVisibility) -> some View {
        if #available(macOS 13.0, iOS 16, visionOS 1, *) {
            switch visibility {
            case .automatic:
                self.scrollContentBackground(.automatic)
            case .visible:
                self.scrollContentBackground(.visible)
            case .hidden:
                self.scrollContentBackground(.hidden)
            }
        } else {
            self
        }
    }

    @ViewBuilder
    func scrollIndicatorsCompat(_ visibility: CompatibilityVisibility) -> some View {
        if #available(macOS 13.0, iOS 16, visionOS 1, *) {
            switch visibility {
            case .automatic:
                self.scrollIndicators(.automatic)
            case .visible:
                self.scrollIndicators(.visible)
            case .hidden:
                self.scrollIndicators(.hidden)
            }
        } else {
            self
        }
    }
}
