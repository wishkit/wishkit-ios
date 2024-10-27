//
//  WishlistContainer.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/11/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if os(macOS) || os(visionOS)
import SwiftUI
import WishKitShared

struct WishlistContainer: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @State
    private var listType: WishState = .inReview

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
            DispatchQueue.main.async {
                isRefreshing = false
            }
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

            WishlistView(wishModel: wishModel, listType: $listType)
                .background(systemBackgroundColor)
            
        }.background(systemBackgroundColor)
    }

    private var feedbackStateSelection: [WishState] {
        return [.pending, .inReview, .planned, .inProgress, .completed]
    }

    private func getCountFor(state: WishState) -> Int {
        switch state {
        case .pending:
            return wishModel.pendingList.count
        case .inReview, .approved:
            return wishModel.inReviewList.count
        case .planned:
            return wishModel.plannedList.count
        case .inProgress:
            return wishModel.inProgressList.count
        case .completed, .implemented:
            return wishModel.completedList.count
        case .rejected:
            return 0
        }
    }

    var segmentedControlView: some View {
        HStack {

            if WishKit.config.buttons.segmentedControl.display == .show {
                Picker("", selection: $listType) {
                    ForEach(feedbackStateSelection) { state in
                        Text("\(state.description) (\(getCountFor(state: state)))")
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

            if WishKit.config.buttons.addButton.location == .navigationBar {
                Button(action: { self.showingCreateSheet.toggle() }) {
                    Text(WishKit.config.localization.addButtonInNavigationBar)
                }
                .padding(.leading, 15)
                .sheet(isPresented: $showingCreateSheet) {
                    CreateWishView(
                        createActionCompletion: { wishModel.fetchList() },
                        closeAction: { self.showingCreateSheet = false }
                    )
                    .frame(minWidth: 500, idealWidth: 500, minHeight: 400, maxHeight: 600)
                    .background(systemBackgroundColor)
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
            }.padding(.trailing, WishKit.config.buttons.addButton.location == .floating ? 15 : 0)

            if WishKit.config.buttons.addButton.location == .navigationBar {
                Button(action: { self.showingCreateSheet.toggle() }) {
                    Text(WishKit.config.localization.addButtonInNavigationBar)
                }
                .padding(.leading, 15)
                .sheet(isPresented: $showingCreateSheet) {
                    CreateWishView(
                        createActionCompletion: { wishModel.fetchList() },
                        closeAction: { self.showingCreateSheet = false }
                    )
                    .frame(minWidth: 500, idealWidth: 500, minHeight: 400, maxHeight: 600)
                    .background(systemBackgroundColor)
                }
            }
        }.padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 15))
    }

    var systemBackgroundColor: Color {
        switch colorScheme {
        case .light:
            if let color = WishKit.theme.tertiaryColor {
                return color.light
            }

            return PrivateTheme.systemBackgroundColor.light
        case .dark:
            if let color = WishKit.theme.tertiaryColor {
                return color.dark
            }

            return PrivateTheme.systemBackgroundColor.dark
        @unknown default:
            if let color = WishKit.theme.tertiaryColor {
                return color.light
            }

            return PrivateTheme.systemBackgroundColor.light
        }
    }
}
#endif
