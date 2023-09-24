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
                    .padding([.top, .bottom], 15)

                ForEach(getList()) { wish in
                    NavigationLink(destination: {
                        DetailWishView(wishResponse: wish, voteActionCompletion: wishModel.fetchList)
                    }, label: {
                        HStack {
                            VStack {
                                Image(systemName: "arrow.up")
                                Text(wish.votingUsers.count.description)
                            }

                            Text(wish.title)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                        .padding([.leading, .bottom, .trailing], 10)
                    })
                }

                Spacer()
            }

        }.onAppear(perform: wishModel.fetchList)
    }
}
#endif
