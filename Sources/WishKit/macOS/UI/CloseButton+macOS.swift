#if os(macOS)
import SwiftUI

struct CloseButton: View {

    private let closeAction: () -> Void

    init(closeAction: @escaping () -> Void) {
        self.closeAction = closeAction
    }

    var body: some View {
        Button(action: closeAction, label: { Image(systemName: "x.circle.fill") })
            .buttonStyle(PlainButtonStyle())
            .foregroundStyle(Color.secondary)
            .padding(.top, 15)
            .padding(.trailing, 15)
    }
}
#endif
