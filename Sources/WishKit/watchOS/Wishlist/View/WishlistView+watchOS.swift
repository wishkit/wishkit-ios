//
//  WishlistView+watchOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/13/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(watchOS)
import SwiftUI
import WishKitShared

struct WishlistView: View {

    @StateObject
    private var viewModel = WishlistViewModel()

    @ObservedObject
    var wishModel: WishModel

    var body: some View {
        NavigationStack {
            Group {
                if wishModel.isLoading && !wishModel.hasFetched {
                    ProgressView()
                } else if wishModel.hasFetched && currentList.isEmpty {
                    Text(WishKit.config.localization.noFeatureRequests)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(currentList) { wish in
                        NavigationLink {
                            DetailWishView(
                                wishResponse: wish,
                                voteActionCompletion: { wishModel.fetchList() }
                            )
                        } label: {
                            WishView(
                                wishResponse: wish,
                                viewKind: .list,
                                voteActionCompletion: { wishModel.fetchList() }
                            )
                        }
                    }
                }
            }
            .navigationTitle(WishKit.config.localization.featureWishlist)
            .onAppear {
                wishModel.fetchList()
            }
        }
    }

    private var currentList: [WishResponse] {
        viewModel.list(for: wishModel)
    }
}
#endif
