//
//  ToolbarCompat.swift
//  
//
//  Created by Martin Lasek on 11/22/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension View {

    @ViewBuilder
    /// If the toolBar is placed in a view that's inside a NavigationStack it doesn't work and this is a bug.
    func toolbarKeyboardDoneButton() -> some View {
        #if canImport(UIKit) && !os(visionOS)
        if #available(macOS 13.0, iOS 15, *) {
            self.toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(
                            action: { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) },
                            label: { Text("Done") }
                        )
                    }
                }
            }
        } else {
            self
        }
        #else
        self
        #endif
    }
}
