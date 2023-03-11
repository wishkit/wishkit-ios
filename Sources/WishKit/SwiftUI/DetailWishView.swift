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
                ScrollView {
                    VStack {
                        Text(title)
                        Text(description)
                    }
                }.padding(EdgeInsets(top: 30, leading: 30, bottom: 20, trailing: 30))

                Button("Close") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                .interactiveDismissDisabled()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
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
