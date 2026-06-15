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

    @State
    private var commentList: [CommentResponse]

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    init(
        wishResponse: WishResponse,
        voteActionCompletion: @escaping (() -> Void)
    ) {
        self.wishResponse = wishResponse
        self.voteActionCompletion = voteActionCompletion
        self._commentList = .init(initialValue: wishResponse.commentList)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                WishView(
                    wishResponse: wishResponse,
                    viewKind: .detail,
                    voteActionCompletion: voteActionCompletion
                )

                if WishKit.config.commentSection == .show && !commentList.isEmpty {
                    CommentListView(commentList: $commentList)
                }
            }
            .padding(40)
        }
        .navigationTitle(WishKit.config.localization.detail)
    }
}
#endif
