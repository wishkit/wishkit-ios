//
//  DetailWishView+iOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/13/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared
import Combine

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

    private let closeAction: () -> Void

    init(wishResponse: WishResponse, voteActionCompletion: @escaping (() -> Void), closeAction: @escaping (() -> Void)) {
        self.wishResponse = wishResponse
        self.voteActionCompletion = voteActionCompletion
        self.closeAction = closeAction
        self._commentList = State(wrappedValue: wishResponse.commentList)
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: closeAction, label: { Image(systemName: "x.circle.fill") })
                    .buttonStyle(PlainButtonStyle())
                    .foregroundStyle(Color.secondary)
            }
            .padding(.top, getButtonPadding().0)
            .padding(.trailing, getButtonPadding().1)

            ScrollView {
                VStack {

                    Spacer(minLength: 15)

                    WishView(wishResponse: wishResponse, viewKind: .detail, voteActionCompletion: voteActionCompletion)
                        .frame(maxWidth: 700)

                    Spacer(minLength: 15)

                    if WishKit.config.commentSection == .show {
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
                }.padding([.leading, .bottom, .trailing])
            }.ignoresSafeArea(edges: [.bottom, .leading, .trailing])

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }

    private func getButtonPadding() -> (CGFloat, CGFloat) {
        #if os(visionOS)
            return (15, 25)
        #else
            return (15, 15)
        #endif
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
