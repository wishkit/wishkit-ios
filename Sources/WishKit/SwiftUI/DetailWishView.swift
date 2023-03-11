//
//  DetailWishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct DetailWishView: View {

    @Environment (\.presentationMode)
    var presentationMode

    @Environment(\.colorScheme)
    var colorScheme

    private var title: String

    private var description: String

    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(backgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 50, trailing: 15))

            VStack {
                HStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text(title).bold().font(.title2)
                            Spacer(minLength: 10)
                            Text(description)
                        }.frame(alignment: .leading)
                    }
                    .padding(EdgeInsets(top: 30, leading: 30, bottom: 20, trailing: 30))
                    Spacer()
                }

                HStack {
                    WKButton(text: "Upvote", action: { print("🔼 upvote call") })
                    WKButton(text: "Close", action: { self.presentationMode.wrappedValue.dismiss() }, style: .secondary)
                    .interactiveDismissDisabled()
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            return PrivateTheme.elementBackgroundColor.light
        case .dark:
            return PrivateTheme.elementBackgroundColor.dark
        }
    }
}
