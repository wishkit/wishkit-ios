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
        if commentList.isEmpty {
            // needed to expand the parent view all the way to the bottom.
            Spacer()
        } else {
            List(commentList, id: \.id) { comment in
                SingleCommentView(
                    comment: comment.description,
                    createdAt: comment.createdAt,
                    isAdmin: comment.isAdmin
                )
                .fullWidthListSeparatorCompat()
            }
        }
    }
}
