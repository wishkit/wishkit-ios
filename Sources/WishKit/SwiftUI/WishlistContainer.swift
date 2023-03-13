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

    @State
    private var listType: WishState = .approved

    @State
    private var isRefreshing = false

    @ObservedObject
    var wishModel: WishModel

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
            ZStack {
                Picker(selection: $listType, content: {
                    Text("Approved").tag(WishState.approved)
                    Text("Implemented").tag(WishState.implemented)
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

            WishlistView(wishModel: wishModel, listType: $listType)
        }
    }
}
#endif
