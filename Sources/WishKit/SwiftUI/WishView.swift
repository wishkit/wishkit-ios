//
//  WishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

struct WishView: View {

    @Environment(\.colorScheme)
    var colorScheme

    private let wish: WishResponse

    init(wish: WishResponse) {
        self.wish = wish
    }

    var body: some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)

            HStack {
                Button(action: voteAction) {
                    VStack(alignment: .center, spacing: 3) {
                        Image(systemName: "triangle.fill")
                            .foregroundColor(.green)
                        Text(wish.votingUsers.count.description)
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                }.buttonStyle(BorderlessButtonStyle())

                VStack(alignment: .leading, spacing: 5) {
                    Text(wish.title)
                        .bold()
                        .truncationMode(.tail)
                        .lineLimit(1)
                    Text(wish.description)
                        .truncationMode(.tail)
                        .lineLimit(1)
                }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                Spacer()
            }
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
        }
    }

    func voteAction() {

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
