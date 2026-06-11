//
//  CommentListView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/7/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

struct CommentListView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @Binding
    var commentList: [CommentResponse]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(WishKit.config.localization.comments)
                .font(.caption2)
                .foregroundColor(.secondary)
                .textCase(nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 8)

            LazyVStack(spacing: 0) {
                ForEach(commentList, id: \.id) { comment in
                    SingleCommentView(
                        comment: comment.description,
                        createdAt: comment.createdAt,
                        isAdmin: comment.isAdmin
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if comment.id != commentList.last?.id {
                        Divider()
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(containerBackground)
            .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
            .padding(.horizontal, 16)
        }
    }

    private var containerBackground: Color {
        WishKit.theme.secondaryColor?.resolved(for: colorScheme) ?? PrivateTheme.elementBackground
    }
}
