//
//  SwiftUIView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/12/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct SingleCommentView: View {

    private let comment: String

    private let createdAt: Date

    private let isAdmin: Bool

    init(comment: String, createdAt: Date, isAdmin: Bool) {
        self.comment = comment
        self.createdAt = createdAt
        self.isAdmin = isAdmin
    }

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {

                Text("\(isAdmin ? WishKit.config.localization.admin : WishKit.config.localization.user)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(createdAt.wkFormatted())
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Text(comment)
                .font(.body)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
    }
}
