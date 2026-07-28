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

    /// Non-nil means the vote alert is presented; the value is its content.
    @State
    private var voteAlert: AlertReason? = nil

    @Binding
    var selectedWishState: LocalWishState

    func getList() -> [WishResponse] {
        if WishKit.config.buttons.segmentedControl.display == .hide {
            return wishModel.all
        }

        switch selectedWishState {
        case .all:
            return wishModel.all
        case .open:
            return (wishModel.pendingList + wishModel.approvedList)
                .sorted { $0.votingUsers.count > $1.votingUsers.count }
        case .closed:
            return wishModel.completedList
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
                        Spacer(minLength: 30)

                        HStack(alignment: .center) {
                            Text(WishKit.config.localization.noFeatureRequests)
                                .font(.title3)
                        }.frame(maxWidth: .infinity)

                        Spacer(minLength: 30)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .transition(.opacity)
            }
                
            if getList().count > 0 {
                List(getList(), id: \.id) { wish in
                    Button(action: { selectWish(wish: wish) }) {
                        WishView(
                            wishResponse: wish,
                            viewKind: .list,
                            voteActionCompletion: { wishModel.fetchList() },
                            onVoteAlert: { reason in voteAlert = reason }
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.bordered)
                    .listRowInsets(EdgeInsets())
                    .fullWidthListSeparator()
                }
                .listStyle(.plain)
                .listRowSpacing(15)
                .scrollContentBackground(.hidden)
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
        // Presented here — outside the List — so a row being recreated
        // (e.g. by a refresh) can never take a visible alert down with it.
        .alert(
            voteAlert.map { WishView.voteAlertMessage(for: $0) } ?? "",
            isPresented: Binding(
                get: { voteAlert != nil },
                set: { if !$0 { voteAlert = nil } }
            ),
            presenting: voteAlert
        ) { _ in
            Button(WishKit.config.localization.ok, role: .cancel) { }
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
