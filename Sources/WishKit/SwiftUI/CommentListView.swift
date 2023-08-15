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
    }
}

struct CommentListView_Previews: PreviewProvider {
    @State
    static var commentList = [
        CommentResponse(id: UUID(), userId: UUID(), description: "The Only Distance That Matters Is The Distance Between Our Hearts.", createdAt: Date(), isAdmin: true),
        CommentResponse(id: UUID(), userId: UUID(), description: "It's dangerous to go alone, take this! - Old Man", createdAt: Date(), isAdmin: true)
    ]

    static var previews: some View {
        CommentListView(commentList: $commentList)
    }
}
