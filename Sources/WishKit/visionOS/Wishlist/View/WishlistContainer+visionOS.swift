//
//  WishlistContainer+visionOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/11/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if os(visionOS)
import SwiftUI
import WishKitShared

struct WishlistContainer: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @StateObject
    private var viewModel = WishlistViewModel()

    @State
    private var isRefreshing = false

    @State
    private var showingCreateSheet = false

    @ObservedObject
    private var wishModel: WishModel

    init(wishModel: WishModel) {
        self.wishModel = wishModel
        self.wishModel.fetchList()
    }

    func refreshList() {
        isRefreshing = true
        wishModel.fetchList {
            isRefreshing = false
        }
    }

    var body: some View {
        VStack {
            switch WishKit.config.buttons.segmentedControl.display {
            case .show:
                segmentedControlView
            case .hide:
                noSegmentedControlView
            }

            WishlistView(
                wishModel: wishModel,
                selectedWishState: $viewModel.selectedWishState
            ).background(systemBackgroundColor)

        }.background(systemBackgroundColor)
    }

    var segmentedControlView: some View {
        HStack {

            if WishKit.config.buttons.segmentedControl.display == .show {
                Picker("", selection: $viewModel.selectedWishState) {
                    ForEach(viewModel.feedbackStateSelection, id: \.self) { state in
                        Text("\(state.description) (\(viewModel.count(for: state, wishModel: wishModel)))")
                            .tag(state)
                    }
                }.frame(maxWidth: 150)
            }

            Spacer()

            Button(action: refreshList) {
                if isRefreshing {
                    Text(WishKit.config.localization.refreshing)
                } else {
                    Text(WishKit.config.localization.refresh)
                }
            }

            createButton
        }.padding(EdgeInsets(top: 15, leading: 15, bottom: 5, trailing: 20))
    }

    var noSegmentedControlView: some View {
        HStack {
            Button(action: refreshList) {
                if isRefreshing {
                    Text(WishKit.config.localization.refreshing)
                } else {
                    Text(WishKit.config.localization.refresh)
                }
            }

            Spacer()

            createButton
        }.padding(EdgeInsets(top: 15, leading: 15, bottom: 5, trailing: 20))
    }

    @ViewBuilder
    var createButton: some View {
        if WishKit.config.buttons.addButton.display == .show {
            Button(action: { showingCreateSheet = true }) {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $showingCreateSheet) {
                CreateWishView(
                    createActionCompletion: { wishModel.fetchList() },
                    closeAction: { self.showingCreateSheet = false }
                )
                .frame(minWidth: 500, idealWidth: 500, minHeight: 400, maxHeight: 600)
                .background(systemBackgroundColor)
            }
        }
    }

    var systemBackgroundColor: Color {
        WishKit.theme.tertiaryColor?.resolved(for: colorScheme) ?? PrivateTheme.systemBackground
    }
}
#endif
