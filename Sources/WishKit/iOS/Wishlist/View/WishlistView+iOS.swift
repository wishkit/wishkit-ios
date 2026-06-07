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

                if wishModel.isLoading && !wishModel.hasFetched {
                    WishlistSkeletonView()
                } else if !currentList.isEmpty {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor.ignoresSafeArea())
        .navigationTitle(WishKit.config.localization.featureWishlist)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if WishKit.config.buttons.doneButton.display == .show {
                ToolbarItem(placement: .topBarLeading) {
                    Button(WishKit.config.localization.done) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            if WishKit.config.buttons.addButton.display == .show {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CreateWishView(createActionCompletion: { wishModel.fetchList() })
                    } label: {
                        Image(systemName: "plus")
                            .accessibilityLabel(WishKit.config.localization.addButtonInNavigationBar)
                    }
                }
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
