//
//  WishlistView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

// MARK: - macOS

#if os(macOS)
extension View {
    @ViewBuilder
    func scrollContentBackgroundCompat(_ visibility: Visibility) -> some View {
        if #available(macOS 13.0, *) {
            self.scrollContentBackground(visibility)
        }
    }

    @ViewBuilder
    func scrollIndicatorsCompat(_ visibility: ScrollIndicatorVisibilityCompat) -> some View {
        if #available(macOS 13.0, *) {
            switch visibility {
            case .automatic:
                self.scrollIndicators(.automatic)
            case .visible:
                self.scrollIndicators(.visible)
            case .hidden:
                self.scrollIndicators(.hidden)
            case .never:
                self.scrollIndicators(.never)
            }
        }
    }

    @ViewBuilder
    func listRowSeparatorCompat(_ visibility: Visibility) -> some View {
        if #available(macOS 13.0, *) {
            self.listRowSeparator(visibility)
        }
    }
}

enum ScrollIndicatorVisibilityCompat {
    case automatic
    case visible
    case hidden
    case never
}

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

            List(getList(), id: \.id) { wish in
                Button(action: { selectedWish = wish }) {
                    WishView(wishResponse: wish, viewKind: .list, voteActionCompletion: { wishModel.fetchList() })
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                }
                .buttonStyle(PlainButtonStyle())
                .listRowSeparatorCompat(.hidden)
            }
            .scrollIndicatorsCompat(.hidden)
            .scrollContentBackgroundCompat(.hidden)
            .sheet(item: $selectedWish, onDismiss: { wishModel.fetchList() }) { wish in
                DetailWishView(wishResponse: wish, voteActionCompletion: { wishModel.fetchList() })
                    .frame(minWidth: 500, idealWidth: 500, minHeight: 500, idealHeight: 500, maxHeight: 600)
                    .background(backgroundColor)
            }
            .onAppear(perform: { wishModel.fetchList() })

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
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
                        .sheet(isPresented: $showingSheet) {
                            CreateWishView(isShowing: $showingSheet, createActionCompletion: { wishModel.fetchList() })
                                .frame(minWidth: 500, idealWidth: 500, minHeight: 500, idealHeight: 500, maxHeight: 600)
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
        }
    }
}
#endif
