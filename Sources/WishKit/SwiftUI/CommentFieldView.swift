//
//  SwiftUIView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/14/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct CommentFieldView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @State
    private var textFieldValue = ""

    var body: some View {
        ZStack {
            TextField("Write a comment..", text: $textFieldValue)
                .font(.footnote)
                .padding([.top, .leading, .bottom], 15)
                .padding([.trailing], 40)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            HStack {
                Spacer()
                Button(action: { print("commenting..") }) {
                    Image(systemName: "paperplane.fill")
                        .padding(10)
                }.foregroundColor(WishKit.theme.primaryColor)
            }
        }
    }
}

extension CommentFieldView {
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

struct CommentFieldView_Previews: PreviewProvider {
    static var previews: some View {
        CommentFieldView()
    }
}
