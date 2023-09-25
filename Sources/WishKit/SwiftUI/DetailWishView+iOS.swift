//
//  SwiftUIView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/13/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//
#if os(iOS)
import SwiftUI
import WishKitShared
import Combine

final class CommentModel: ObservableObject {
    @Published
    var newCommentValue = ""

    @Published
    var isLoading = false
}

struct DetailWishView: View {

    // MARK: - Private

    @Environment(\.colorScheme)
    private var colorScheme

    @ObservedObject
    private var commentModel = CommentModel()

    @State
    private var commentList: [CommentResponse] = []

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    init(wishResponse: WishResponse, voteActionCompletion: @escaping (() -> Void)) {
        self.wishResponse = wishResponse
        self.voteActionCompletion = voteActionCompletion
        self._commentList = State(wrappedValue: wishResponse.commentList)
    }

    var body: some View {
        ScrollView {
            VStack {

                Spacer(minLength: 15)

                WKWishView(wishResponse: wishResponse, voteActionCompletion: voteActionCompletion)
                    .frame(maxWidth: 700)

                Spacer(minLength: 15)

                SeparatorView()
                    .padding([.top, .bottom], 15)

                CommentFieldView($commentModel.newCommentValue, isLoading: $commentModel.isLoading) {
                    let request = CreateCommentRequest(wishId: wishResponse.id, description: commentModel.newCommentValue)

                    commentModel.isLoading = true
                    let response = await CommentApi.createComment(request: request)
                    commentModel.isLoading = false

                    switch response {
                    case .success(let commentResponse):
                        withAnimation {
                            commentList.insert(commentResponse, at: 0)
                        }

                        commentModel.newCommentValue = ""
                    case .failure(let error):
                        print("❌ \(error.localizedDescription)")
                    }
                }.frame(maxWidth: 700)

                Spacer(minLength: 20)

                CommentListView(commentList: $commentList)
                    .frame(maxWidth: 700)
            }
            .padding()
        }
        .background(backgroundColor)
        .ignoresSafeArea(edges: [.bottom, .leading, .trailing])
    }
}

// MARK: - Color Scheme

extension DetailWishView {

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            if let color = WishKit.theme.tertiaryColor {
                return color.light
            }

            return PrivateTheme.systemBackgroundColor.light
        case .dark:
            if let color = WishKit.theme.tertiaryColor {
                return color.dark
            }

            return PrivateTheme.systemBackgroundColor.dark
        }
    }
}
#endif
