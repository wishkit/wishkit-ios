#if os(iOS)
import SwiftUI

extension View {
    @ViewBuilder
    func toolbarKeyboardDoneButton() -> some View {
        if #available(iOS 15, *) {
            self.toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(
                            action: {
                                UIApplication.shared.sendAction(
                                    #selector(UIResponder.resignFirstResponder),
                                    to: nil,
                                    from: nil,
                                    for: nil
                                )
                            },
                            label: { Text("Done") }
                        )
                    }
                }
            }
        } else {
            self
        }
    }
}
#endif
