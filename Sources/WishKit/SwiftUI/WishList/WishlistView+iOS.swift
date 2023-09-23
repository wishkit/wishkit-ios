//
//  SwiftUIView.swift
//  
//
//  Created by Martin Lasek on 9/15/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//
#if os(iOS)
import SwiftUI
import WishKitShared

struct WishlistViewIOS: View {

    @State
    private var selectedWishState: WishState = .approved

    @ObservedObject
    var wishModel: WishModel

    @State
    var selectedWish: WishResponse? = nil

    private func getList() -> [WishResponse] {
        switch selectedWishState {
        case .approved:
            return wishModel.approvedWishlist
        case .implemented:
            return wishModel.implementedWishlist
        default:
            return []
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SegmentedView(selectedWishState: $selectedWishState)
                    .frame(maxWidth: 200)

                List(getList(), id: \.id) { wish in
                    NavigationLink(destination: {
                        DetailWishView(wishResponse: wish, voteActionCompletion: wishModel.fetchList)
                    }, label: {
                        Text(wish.title)
                    })
                }
            }

        }.onAppear(perform: wishModel.fetchList)
    }
}
#endif
