//
//  SwiftUIView.swift
//  
//
//  Created by Martin Lasek on 8/12/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct SingleCommentView: View {

    private let cornerRadius: CGFloat = 12

    private let comment: String

    private let createdAt: Date

    private let isAdmin: Bool

    init(comment: String, createdAt: Date, isAdmin: Bool) {
        self.comment = comment
        self.createdAt = createdAt
        self.isAdmin = isAdmin
    }

    var body: some View {
        VStack {
            HStack {
                Text(comment)
                    .padding(15)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(cornerRadius) // make the background rounded
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.gray.opacity(2/3), lineWidth: 0.5)
            )

            HStack {
                Spacer()
                HStack(spacing: 0) {
                    Text(createdAt, style: .date)
                        .font(.footnote)
                        .foregroundColor(.black.opacity(2/3))
                    Text(" • Admin")
                        .font(.footnote)
                        .foregroundColor(.black.opacity(2/3))
                }.padding(.trailing, 10)

            }
        }
    }
}

struct SingleCommentView_Previews: PreviewProvider {
    static var previews: some View {
        SingleCommentView(
            comment: "Hey! Listen! It's dangerous to go alone. Take this!",
            createdAt: Date(),
            isAdmin: Bool.random()
        )
    }
}
