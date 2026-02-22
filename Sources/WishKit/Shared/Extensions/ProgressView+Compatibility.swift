import SwiftUI

extension ProgressView {

    @ViewBuilder
    func controlSizeCompat(_ controlSize: CompatibilityControlSize) -> some View {
        if #available(iOS 15, *) {
            switch controlSize {
            case .mini:
                self.controlSize(.mini)
            case .small:
                self.controlSize(.small)
            case .regular:
                self.controlSize(.regular)
            case .large:
                self.controlSize(.large)
            }
        } else {
            self
        }
    }
}
