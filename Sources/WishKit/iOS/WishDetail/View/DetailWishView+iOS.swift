//
//  DetailWishView+iOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/13/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import WishKitShared

struct DetailWishView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @StateObject
    private var viewModel: DetailWishViewModel

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    init(
        wishResponse: WishResponse,
        voteActionCompletion: @escaping (() -> Void)
    ) {
        self.wishResponse = wishResponse
        self.voteActionCompletion = voteActionCompletion
        self._viewModel = StateObject(
            wrappedValue: DetailWishViewModel(commentList: wishResponse.commentList)
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                WishView(wishResponse: wishResponse, viewKind: .detail, voteActionCompletion: voteActionCompletion)
                    .padding()
                    .frame(maxWidth: 700)

                if WishKit.config.commentSection == .show, $viewModel.commentList.isEmpty == false {
                    CommentListView(commentList: $viewModel.commentList)
                        .frame(maxWidth: 700)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(backgroundColor)
        .navigationTitle(WishKit.config.localization.detail)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            if WishKit.config.commentSection == .show {
                CommentFieldView($viewModel.newCommentValue, isLoading: $viewModel.isLoading) {
                    await viewModel.submitComment(for: wishResponse.id)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
}

// MARK: - Color Scheme

extension DetailWishView {

    var backgroundColor: Color {
        WishKit.theme.tertiaryColor?.resolved(for: colorScheme) ?? PrivateTheme.systemBackground
    }
}
#endif
