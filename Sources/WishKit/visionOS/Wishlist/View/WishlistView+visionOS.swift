//
//  WishlistView+visionOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if os(visionOS)
import SwiftUI
import WishKitShared

struct WishlistView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @ObservedObject
    var wishModel: WishModel

    @State
    var selectedWish: WishResponse? = nil

    @Binding
    var selectedWishState: LocalWishState

    func getList() -> [WishResponse] {
        if WishKit.config.buttons.segmentedControl.display == .hide {
            return wishModel.all
        }

        switch selectedWishState {
        case .all:
            return wishModel.all
        case .library(let state):
            switch state {
            case .pending:
                return wishModel.pendingList
            case .approved, .inReview, .planned, .inProgress:
                return wishModel.approvedList
            case .completed, .implemented:
                return wishModel.completedList
            case .rejected:
                return []
            }
        }
    }

    var body: some View {
        ZStack {

            if wishModel.isLoading && (!wishModel.hasFetched || getList().isEmpty) {
                WishlistSkeletonView()
            }

            if wishModel.hasFetched && !wishModel.isLoading && getList().isEmpty {
                List {
                    VStack {
                        Spacer(minLength: 20)

                        HStack(alignment: .center) {
                            Text(WishKit.config.localization.noFeatureRequests)
                                .font(.title3)
                        }.frame(maxWidth: .infinity)
                        
                        Spacer(minLength: 20)
                    }
                }.transition(.opacity)
            }

            if getList().count > 0 {
                List(getList(), id: \.id) { wish in
                    Button(action: { selectWish(wish: wish) }) {
                        WishView(wishResponse: wish, viewKind: .list, voteActionCompletion: { wishModel.fetchList() })
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .fullWidthListSeparator()
                }
                .transition(.opacity)
                .sheet(item: $selectedWish, onDismiss: { wishModel.fetchList() }) { wish in
                    DetailWishView(
                        wishResponse: wish,
                        voteActionCompletion: { wishModel.fetchList() },
                        closeAction: { self.selectedWish = nil }
                    )
                    .frame(minWidth: 500, idealWidth: 500, minHeight: 450, maxHeight: 600)
                    .background(backgroundColor)
                }.onAppear(perform: { wishModel.fetchList() })
            }

            if wishModel.shouldShowWatermark {
                VStack {
                    Spacer()
                    Text("\(WishKit.config.localization.poweredBy) WishKit.io")
                        .opacity(0.33)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                }.zIndex(0)
            }
        }
    }

    private func selectWish(wish: WishResponse) {
        self.selectedWish = wish
    }

    var backgroundColor: Color {
        WishKit.theme.tertiaryColor?.resolved(for: colorScheme) ?? PrivateTheme.systemBackground
    }
}
#endif
