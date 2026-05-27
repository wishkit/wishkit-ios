//
//  WishlistSegmentedControlSectionView+iOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 5/25/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import WishKitShared

struct WishlistSegmentedControlSectionView: View {
    
    @Binding
    var selectedWishState: LocalWishState
    
    let feedbackStateSelection: [LocalWishState]
    
    let countProvider: (LocalWishState) -> Int
    
    var body: some View {
        Spacer(minLength: 15)
        Picker("", selection: $selectedWishState) {
            ForEach(feedbackStateSelection, id: \.self) { state in
                Text("\(state.description) (\(countProvider(state)))")
                    .tag(state)
            }
        }
    }
}
#endif
