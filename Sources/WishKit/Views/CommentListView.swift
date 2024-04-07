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
        LazyVStack {
            ForEach(self.commentList, id: \.id) { comment in
                SingleCommentView(
                    comment: comment.description,
                    createdAt: comment.createdAt,
                    isAdmin: comment.isAdmin
                )
                .padding(.bottom, 10)
            }
        }
        .padding(1)
        .padding(.bottom, 30)
    }
}
