//
//  WishlistContainer.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/11/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

struct WishlistContainer: View {

    @State
    private var listType: WishState = .approved

    var body: some View {

        VStack {
            Picker(selection: $listType, content: {
                Text("Approved").tag(WishState.approved)
                Text("Implemented").tag(WishState.implemented)
            }, label: {
                EmptyView()
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            WishlistView(listType: $listType)
        }
    }
}
