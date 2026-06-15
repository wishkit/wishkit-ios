//
//  DetailWishView+tvOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/14/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(tvOS)
import SwiftUI
import WishKitShared

struct DetailWishView: View {

    let wishResponse: WishResponse

    let voteActionCompletion: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                WishView(
                    wishResponse: wishResponse,
                    viewKind: .detail,
                    voteActionCompletion: voteActionCompletion
                )

                if WishKit.config.commentSection == .show && !wishResponse.commentList.isEmpty {
                    CommentListView(commentList: .constant(wishResponse.commentList))
                }
            }
            .padding(40)
        }
        .navigationTitle(WishKit.config.localization.detail)
    }
}
#endif
