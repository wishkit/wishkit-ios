#if os(iOS)
import SwiftUI

extension View {
    func toolbarKeyboardDoneButton() -> some View {
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
    }
}
#endif
