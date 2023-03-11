//
//  WishlistView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

extension WishResponse: Identifiable { }

struct WishlistView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    private var wishModel = WishModel()

    @State
    private var showingSheet = false

    @State
    private var selectedWish: WishResponse?

    var body: some View {

        if #available(macOS 13.0, *) {
            ZStack {
                List(wishModel.wishlist, id: \.id) { wish in
                    Button(action: { selectedWish = wish }) {
                        WishView(wish: wish)
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .sheet(item: $selectedWish) { wish in
                    DetailWishView(title: wish.title, description: wish.description)
                        .frame(minWidth: 400, idealWidth: 400, maxWidth: 400, minHeight: 300, maxHeight: 400)
                }
                .scrollIndicators(.hidden)
                .background(systemBackgroundColor)
                .scrollContentBackground(.hidden)
                .onAppear(perform: wishModel.fetchList)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        WKAddButton(buttonAction: createWishAction)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
                            .sheet(isPresented: $showingSheet) {
                                CreateWishView(completion: {
                                    wishModel.fetchList()
                                    showingSheet = false
                                })
                                .frame(minWidth: 400, idealWidth: 400, maxWidth: 400, minHeight: 300, maxHeight: 400)
                            }
                    }
                }
            }

        } else {
            List(wishModel.wishlist, id: \.id) { wish in
                WishView(wish: wish)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            }
            .background(systemBackgroundColor)
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    WKAddButton(buttonAction: createWishAction)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 20))
                }
            }
        }
    }

    private func createWishAction() {
        self.showingSheet.toggle()
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

//struct WishlistViewPreview: PreviewProvider {
//    static var previews: some View {
//        WishlistView()
//    }
//}
