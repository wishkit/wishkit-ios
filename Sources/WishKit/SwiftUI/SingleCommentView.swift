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
                    .foregroundColor(textColor)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(cornerRadius) // make the background rounded
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.gray.opacity(2/3), lineWidth: 0.5)
            )

            HStack {
                Spacer()
                HStack(spacing: 0) {
                    Text(createdAt, style: .date)
                        .font(.caption2)
                        .foregroundColor(textColor.opacity(2/3))
                    Text(" • \(isAdmin ? "Admin" : "User")")
                        .font(.caption2)
                        .foregroundColor(textColor.opacity(2/3))
                }.padding(.trailing, 10)
            }
        }
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
