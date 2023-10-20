//
//  WishlistView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

#if os(macOS)
struct WishlistView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @ObservedObject
    var wishModel: WishModel

    @State
    var showingSheet = false

    @State
    var selectedWish: WishResponse? = nil

    @Binding
    var listType: WishState

    func getList() -> [WishResponse] {
        switch listType {
        case .approved:
            return wishModel.approvedWishlist
        case .implemented:
            return wishModel.implementedWishlist
        default:
            return []
        }
    }

    private func createWishAction() {
        self.showingSheet.toggle()
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
                    Button(action: { selectedWish = wish }) {
                        WishView(wishResponse: wish, viewKind: .list, voteActionCompletion: { wishModel.fetchList() })
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    }
                    .listRowSeparatorCompat(.hidden)
                    .buttonStyle(.plain)
                }
                .transition(.opacity)
                .scrollIndicatorsCompat(.hidden)
                .scrollContentBackgroundCompat(.hidden)
                .sheet(item: $selectedWish, onDismiss: { wishModel.fetchList() }) { wish in
                    DetailWishView(wishResponse: wish, voteActionCompletion: { wishModel.fetchList() })
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
                    AddButton(buttonAction: createWishAction)
                        .padding([.bottom, .trailing], 20)
                        .sheet(isPresented: $showingSheet) {
                            CreateWishView(createActionCompletion: { wishModel.fetchList() })
                                .frame(minWidth: 500, idealWidth: 500, minHeight: 400, maxHeight: 600)
                            .background(backgroundColor)
                        }
                }
            }
        }
    }

    var backgroundColor: Color {
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
