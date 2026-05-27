//
//  DetailWishView+visionOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/13/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if os(visionOS)
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
        VStack(spacing: 0) {
            HStack {
                Spacer()
                CloseButton(closeAction: { closeAction?() })
            }

            VStack {

                WishView(wishResponse: wishResponse, viewKind: .detail, voteActionCompletion: voteActionCompletion)
                    .padding()
                    .frame(maxWidth: 700)

                if WishKit.config.commentSection == .show {
                    SeparatorView()
                        .padding([.leading, .trailing])
                        .padding([.top, .bottom], 15)

                    CommentFieldView($viewModel.newCommentValue, isLoading: $viewModel.isLoading) {
                        await viewModel.submitComment(for: wishResponse.id)
                    }
                    .padding([.leading, .trailing])
                    .frame(maxWidth: 700)

                    CommentListView(commentList: $viewModel.commentList)
                        .frame(maxWidth: 700, maxHeight: .infinity)
                } else {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if WishKit.config.commentSection == .hide {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
}

// MARK: - Color Scheme

extension DetailWishView {

    var backgroundColor: Color {
        WishKit.theme.tertiaryColor?.resolved(for: colorScheme) ?? PrivateTheme.systemBackground
    }
}
#endif
