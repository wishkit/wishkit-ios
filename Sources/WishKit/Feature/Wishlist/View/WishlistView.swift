//
//  WishlistView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

#if os(macOS) || os(visionOS)
struct WishlistView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @ObservedObject
    var wishModel: WishModel

    @State
    var showingCreateSheet = false

    @State
    var selectedWish: WishResponse? = nil

    @Binding
    var selectedWishState: LocalWishState

    func getList() -> [WishResponse] {
        if WishKit.config.buttons.segmentedControl.display == .hide {
            // No picker shown -> render the unfiltered combined list.
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

    private func createWishAction() {
        self.showingCreateSheet.toggle()
    }

    var body: some View {
        ZStack {

            if wishModel.isLoading && !wishModel.hasFetched {
                ProgressView()
                    .imageScale(.small)
            }

            if wishModel.hasFetched && !wishModel.isLoading && getList().isEmpty {
                Text(WishKit.config.localization.noFeatureRequests)
            }

            if getList().count > 0 {
                List(getList(), id: \.id) { wish in
                    Button(action: { selectWish(wish: wish) }) {
                        WishView(wishResponse: wish, viewKind: .list, voteActionCompletion: { wishModel.fetchList() })
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    }
                    .listRowSeparatorCompat(.hidden)
                    .buttonStyle(.plain)
                }
                .transition(.opacity)
                .scrollIndicatorsCompat(.hidden)
                .scrollContentBackgroundCompat(.hidden)
                .listStyle(PlainListStyle())
                .background(.clear)
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

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if WishKit.config.buttons.addButton.location == .floating {
                        AddButton(buttonAction: createWishAction)
                            .padding([.bottom, .trailing], 20)
                            .sheet(isPresented: $showingCreateSheet) {
                                CreateWishView(
                                    createActionCompletion: { wishModel.fetchList() },
                                    closeAction: { self.showingCreateSheet = false }
                                )
                                .frame(minWidth: 500, idealWidth: 500, minHeight: 400, maxHeight: 600)
                                .background(backgroundColor)
                            }
                    }
                }
            }
        }
    }

    private func selectWish(wish: WishResponse) {
        self.selectedWish = wish
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            WishKit.theme.tertiaryColor?.light ?? PrivateTheme.systemBackgroundColor.light
        case .dark:
            WishKit.theme.tertiaryColor?.dark ?? PrivateTheme.systemBackgroundColor.dark
        @unknown default:
            WishKit.theme.tertiaryColor?.light ?? PrivateTheme.systemBackgroundColor.light
        }
    }
}
#endif
