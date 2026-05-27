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
            )
                .background(systemBackgroundColor)

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
        }.padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 20))
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
            .padding(.trailing, 15)
        }.padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 15))
    }

    var systemBackgroundColor: Color {
        WishKit.theme.tertiaryColor?.resolved(for: colorScheme) ?? PrivateTheme.systemBackground
    }
}
#endif
