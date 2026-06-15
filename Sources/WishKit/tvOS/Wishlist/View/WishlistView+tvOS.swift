//
//  WishlistView+tvOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/14/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(tvOS)
import SwiftUI
import WishKitShared

extension View {
    public func withNavigation() -> some View {
        NavigationStack {
            self
        }
    }
}

struct WishlistView: View {

    @StateObject
    private var viewModel = WishlistViewModel()

    @ObservedObject
    var wishModel: WishModel

    var body: some View {
        Group {
            if wishModel.isLoading && !wishModel.hasFetched {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if wishModel.hasFetched && currentList.isEmpty {
                Text(WishKit.config.localization.noFeatureRequests)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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

    private var currentList: [WishResponse] {
        viewModel.list(for: wishModel)
    }
}
#endif
