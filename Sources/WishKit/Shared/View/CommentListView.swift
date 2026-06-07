//
//  SwiftUIView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/12/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

struct CommentListView: View {

    @Binding
    var commentList: [CommentResponse]

    var body: some View {
        List {
            Section {
                ForEach(commentList, id: \.id) { comment in
                    SingleCommentView(
                        comment: comment.description,
                        createdAt: comment.createdAt,
                        isAdmin: comment.isAdmin
                    )
                    .fullWidthListSeparator()
                }
            } header: {
                Text(WishKit.config.localization.comments)
                    .font(.caption2)
                    .textCase(nil)
            }
        }
    }
}
