//
//  WishlistNavigationBarActionsView+iOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 5/26/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(iOS)
import SwiftUI

struct WishlistNavigationBarActionsView: View {

    let isDoneButtonVisible: Bool

    let isAddButtonVisible: Bool

    let dismissAction: () -> Void

    let createActionCompletion: () -> Void

    var body: some View {
        HStack {
            if isDoneButtonVisible {
                Button(WishKit.config.localization.done) {
                    dismissAction()
                }
            }

            if isAddButtonVisible {
                NavigationLink {
                    CreateWishView(createActionCompletion: createActionCompletion)
                } label: {
                    Image(systemName: "plus")
                        .accessibilityLabel(WishKit.config.localization.addButtonInNavigationBar)
                }
            }
        }
    }
}
#endif
