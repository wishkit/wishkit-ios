//
//  WishlistView+iOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 5/26/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(iOS)
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

    @Environment(\.colorScheme)
    private var colorScheme

    @Environment(\.presentationMode)
    private var presentationMode

    @StateObject
    private var viewModel = WishlistViewModel()

    @ObservedObject
    var wishModel: WishModel

    var body: some View {
        ZStack {

            if wishModel.isLoading && !wishModel.hasFetched {
                ProgressView()
                    .imageScale(.large)
            }

            if wishModel.hasFetched && !wishModel.isLoading && currentList.isEmpty {
                Text("\(viewModel.selectedWishState.description): \(WishKit.config.localization.noFeatureRequests)")
            }

            VStack(spacing: 0) {
                if WishKit.config.buttons.segmentedControl.display == .show {
                    WishlistSegmentedControlSectionView(
                        selectedWishState: $viewModel.selectedWishState,
                        feedbackStateSelection: viewModel.feedbackStateSelection,
                        countProvider: { state in
                            viewModel.count(for: state, wishModel: wishModel)
                        }
                    )
                }

                if !currentList.isEmpty {
                    List(currentList) { wish in
                        NavigationLink(destination: {
                            DetailWishView(wishResponse: wish, voteActionCompletion: { wishModel.fetchList() })
                        }, label: {
                            WishView(wishResponse: wish, viewKind: .list, voteActionCompletion: { wishModel.fetchList() })
                        })
                        .fullWidthListSeparator()
                    }
                    .refreshable { await wishModel.fetchListAsync() }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .ignoresSafeArea(edges: [.leading, .bottom, .trailing])
        .navigationTitle(WishKit.config.localization.featureWishlist)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                WishlistNavigationBarActionsView(
                    isDoneButtonVisible: WishKit.config.buttons.doneButton.display == .show,
                    isAddButtonVisible: WishKit.config.buttons.addButton.display == .show,
                    dismissAction: { presentationMode.wrappedValue.dismiss() },
                    createActionCompletion: { wishModel.fetchList() }
                )
            }
        }
        .onAppear { wishModel.fetchList() }
    }

    private var currentList: [WishResponse] {
        viewModel.list(for: wishModel)
    }
}

extension WishlistView {
    var backgroundColor: Color {
        WishKit.theme.tertiaryColor?.resolved(for: colorScheme) ?? PrivateTheme.systemBackground
    }
}
#endif
