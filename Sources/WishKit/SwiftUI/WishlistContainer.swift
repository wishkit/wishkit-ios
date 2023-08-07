//
//  WishlistContainer.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/11/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

#if os(macOS)
struct WishlistContainer: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @State
    private var listType: WishState = .approved

    @State
    private var isRefreshing = false

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

    var segmentedControlView: some View {
        ZStack {
            Picker(selection: $listType, content: {
                Text(WishKit.config.localization.requested).tag(WishState.approved)
                Text(WishKit.config.localization.implemented).tag(WishState.implemented)
            }, label: {
                EmptyView()
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .frame(maxWidth: 300)

            HStack {
                Button(action: refreshList) {
                    if isRefreshing {
                        ProgressView()
                            .scaleEffect(0.4)
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 20, height: 20)
                .padding(EdgeInsets(top: 0, leading: 315, bottom: 0, trailing: 0))
            }
        }
    }

    var noSegmentedControlView: some View {
        Button(action: refreshList) {
            if isRefreshing {
                ProgressView()
                    .scaleEffect(0.4)
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Image(systemName: "arrow.clockwise")
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 20, height: 20)
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
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
        }
    }
}
#endif
