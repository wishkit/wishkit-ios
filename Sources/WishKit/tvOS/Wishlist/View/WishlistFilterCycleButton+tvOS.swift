//
//  WishlistFilterCycleButton+tvOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/15/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(tvOS)
import SwiftUI
import WishKitShared

struct WishlistFilterCycleButton: View {

    @Binding
    var selectedWishState: LocalWishState

    let feedbackStateSelection: [LocalWishState]

    let countProvider: (LocalWishState) -> Int

    var body: some View {
        Button(action: cycleToNextState) {
            HStack(spacing: 12) {
                Text("\(selectedWishState.description) (\(countProvider(selectedWishState)))")
                    .font(.headline)
                    .lineLimit(1)

                Image(systemName: "chevron.up.chevron.down")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.bordered)
        .accessibilityLabel(accessibilityLabel)
    }

    private func cycleToNextState() {
        guard let currentIndex = feedbackStateSelection.firstIndex(of: selectedWishState) else {
            selectedWishState = feedbackStateSelection.first ?? selectedWishState
            return
        }

        let nextIndex = (currentIndex + 1) % feedbackStateSelection.count
        selectedWishState = feedbackStateSelection[nextIndex]
    }

    private var accessibilityLabel: String {
        let current = selectedWishState.description
        let count = countProvider(selectedWishState)
        return "Filter: \(current), \(count) items. Activate to switch filter."
    }
}
#endif
