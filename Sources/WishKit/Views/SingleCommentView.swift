//
//  SwiftUIView.swift
//  wishkit-ios
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
        VStack(spacing: 0) {
            HStack(spacing: 0){

                Text("\(isAdmin ? WishKit.config.localization.admin : WishKit.config.localization.user)")
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
        .wkShadow()
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
