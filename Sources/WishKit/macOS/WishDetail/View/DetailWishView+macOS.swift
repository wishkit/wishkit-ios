//
//  DetailWishView+macOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/7/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(macOS)
import SwiftUI
import WishKitShared

struct DetailWishView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @StateObject
    private var viewModel: DetailWishViewModel

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    private let closeAction: (() -> Void)?

    init(
        wishResponse: WishResponse,
        voteActionCompletion: @escaping (() -> Void),
        closeAction: (() -> Void)? = nil
    ) {
        self.wishResponse = wishResponse
        self.voteActionCompletion = voteActionCompletion
        self.closeAction = closeAction
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
        .background(backgroundColor)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                if WishKit.config.commentSection == .show {
                    CommentFieldView($viewModel.newCommentValue, isLoading: $viewModel.isLoading) {
                        await viewModel.submitComment(for: wishResponse.id)
                    }
                }

                Button(action: { closeAction?() }) {
                    Text(WishKit.config.localization.close)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .keyboardShortcut(.cancelAction)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .padding(.top, 8)
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
