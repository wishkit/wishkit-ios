//
//  WishlistView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

struct WishlistView: View {

    @State
    var wishlist: [WishResponse] = MockData.wishlist

    @Environment(\.colorScheme)
    var colorScheme

    var body: some View {
        
        if #available(macOS 13.0, *) {
            List(wishlist, id: \.id) { wish in
                WishView(wish: wish)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            }
            .background(systemBackgroundColor)
            .scrollContentBackground(.hidden)

        } else {
            List(wishlist, id: \.id) { wish in
                WishView(wish: wish)
            }
            .background(systemBackgroundColor)
        }
    }

    var systemBackgroundColor: Color {
        switch colorScheme {
        case .light:
            return PrivateTheme.systemBackgroundColor.light
        case .dark:
            return PrivateTheme.systemBackgroundColor.dark
        }
    }
}

struct WishlistViewPreview: PreviewProvider {
    static var previews: some View {
        WishlistView()
    }
}
