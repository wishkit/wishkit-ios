//
//  WishlistView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

extension WishResponse: Identifiable { }

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

    @StateObject
    var wishModel = WishModel()

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

    func voteAction() {
        
        print("⬆️ Voting..")
    }

    private func createWishAction() {
        self.showingSheet.toggle()
    }

    var body: some View {
        ZStack {
            List(getList(), id: \.id) { wish in
                Button(action: { selectedWish = wish }) {
                    WishView(wish: wish, voteCompletion: wishModel.fetchList)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .scrollContentBackgroundCompat(.hidden)
            .sheet(item: $selectedWish, onDismiss: { wishModel.fetchList() }) { wish in
                DetailWishView(wish: wish, voteCompletion: wishModel.fetchList)
                    .frame(minWidth: 400, idealWidth: 400, maxWidth: 400, minHeight: 300, maxHeight: 400)
            }
            .scrollContentBackgroundCompat(.hidden)
            .scrollIndicatorsCompat(.hidden)
            .background(systemBackgroundColor)
            .onAppear(perform: wishModel.fetchList)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    WKAddButton(buttonAction: createWishAction)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
                        .sheet(isPresented: $showingSheet) {
                            CreateWishView(completion: {
                                wishModel.fetchList()
                                showingSheet = false
                            })
                            .frame(minWidth: 400, idealWidth: 400, maxWidth: 400, minHeight: 300, maxHeight: 400)
                        }
                }
            }
        }
    }

    var systemBackgroundColor: Color {
        switch colorScheme {
        case .light:
            return PrivateTheme.systemBackgroundColor.light
        case .dark:
            return PrivateTheme.systemBackgroundColor.dark
        }
    }
}

//struct WishlistViewPreview: PreviewProvider {
//    static var previews: some View {
//        WishlistView()
//    }
//}
