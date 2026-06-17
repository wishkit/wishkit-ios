//
//  DetailWishView+visionOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/7/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
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
    
    @State
    private var submitTask: Task<Void, Never>?

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
                    CommentFieldView($viewModel.newCommentValue, isLoading: $viewModel.isLoading)
                }
                
                HStack(spacing: 8) {
                    Button(action: { closeAction?() }) {
                        Text(WishKit.config.localization.close)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .keyboardShortcut(.cancelAction)

                    Button(action: submitAction) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .controlSize(.small)
                            } else {
                                Text(WishKit.config.localization.submitComment)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(WishKit.theme.primaryColor)
                    .keyboardShortcut(.defaultAction)
                    .disabled(viewModel.newCommentValue.isEmpty || viewModel.isLoading)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            .padding(.top, 8)
        }.onDisappear {
            submitTask?.cancel()
            submitTask = nil
        }
    }
    
    private func submitAction() {
        submitTask?.cancel()
        submitTask = Task { @MainActor in
            defer { submitTask = nil }
            do {
                try await viewModel.submitComment(for: wishResponse.id)
            } catch {
                printError(self, error.localizedDescription)
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
