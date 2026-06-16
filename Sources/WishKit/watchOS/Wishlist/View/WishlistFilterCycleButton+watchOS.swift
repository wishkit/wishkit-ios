//
//  WishlistFilterCycleButton+watchOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/15/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(watchOS)
import SwiftUI
import WishKitShared

struct WishlistFilterCycleButton: View {

    @Binding
    var selectedWishState: LocalWishState

    let feedbackStateSelection: [LocalWishState]

    let countProvider: (LocalWishState) -> Int

    var body: some View {
        Button(action: cycleToNextState) {
            HStack(spacing: 6) {
                Text("\(selectedWishState.description) (\(countProvider(selectedWishState)))")
                    .font(.footnote.weight(.semibold))
                    .lineLimit(1)

                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.25))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
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
