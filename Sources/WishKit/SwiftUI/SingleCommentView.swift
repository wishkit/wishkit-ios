//
//  SwiftUIView.swift
//  
//
//  Created by Martin Lasek on 8/12/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct SingleCommentView: View {

    @Environment(\.colorScheme)
    var colorScheme

    private let cornerRadius: CGFloat = 10

    private let comment: String

    private let createdAt: Date

    private let isAdmin: Bool

    init(comment: String, createdAt: Date, isAdmin: Bool) {
        self.comment = comment
        self.createdAt = createdAt
        self.isAdmin = isAdmin
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0){

                Text("\(isAdmin ? "Admin" : "User")")
                    .font(.caption2)
                    .foregroundColor(textColor.opacity(1/3))
                Spacer()
                Text(createdAt.wkFormatted())
                    .font(.caption2)
                    .foregroundColor(textColor.opacity(1/3))
            }
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing], 10)

            Divider()

            HStack {
                Text(comment)
                    .font(.footnote)
                    .padding(10)
                    .foregroundColor(textColor)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: .black.opacity(1/5), radius: 4, y: 3)
    }

    var textColor: Color {
        switch colorScheme {
        case .light:
            if let color = WishKit.theme.textColor {
                return color.light
            }

            return .black
        case .dark:
            if let color = WishKit.theme.textColor {
                return color.dark
            }

            return .white
        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:

            if let color = WishKit.theme.secondaryColor {
                return color.light
            }

            return PrivateTheme.elementBackgroundColor.light
        case .dark:
            if let color = WishKit.theme.secondaryColor {
                return color.dark
            }

            return PrivateTheme.elementBackgroundColor.dark
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
