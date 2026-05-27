//
//  View+ToolbarKeyboardDoneButton+iOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 5/26/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

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
