//
//  WishKit+FeedbackListView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import SwiftUI

extension WishKit {
    /// FeedbackView that renders the list of feedback.
    public struct FeedbackListView: View {

        public init() {}

        public var body: some View {
            #if os(iOS)
                WishlistView(wishModel: WishModel())
            #elseif os(macOS)
                WishlistContainer(wishModel: WishModel())
            #elseif os(visionOS)
                WishlistContainer(wishModel: WishModel())
            #elseif os(watchOS)
                WishlistView(wishModel: WishModel())
            #elseif os(tvOS)
                WishlistView(wishModel: WishModel())
            #endif
        }
    }
}
