//
//  DetailWishView+watchOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/13/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(watchOS)
import SwiftUI
import WishKitShared

struct DetailWishView: View {

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    init(
        wishResponse: WishResponse,
        voteActionCompletion: @escaping (() -> Void)
    ) {
        self.wishResponse = wishResponse
        self.voteActionCompletion = voteActionCompletion
    }

    var body: some View {
        ScrollView {
            WishView(
                wishResponse: wishResponse,
                viewKind: .detail,
                voteActionCompletion: voteActionCompletion
            )
            .padding(.horizontal)
        }
        .navigationTitle(WishKit.config.localization.detail)
    }
}
#endif
