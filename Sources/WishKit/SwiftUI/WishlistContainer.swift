//
//  WishlistContainer.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/11/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct WishlistContainer: View {

    @State
    private var listType = 0

    var body: some View {

        VStack {
            Picker(selection: $listType, content: {
                Text("Approved").tag(0)
                Text("Implemented").tag(1)
            }, label: {
                EmptyView()
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            WishlistView()
        }
    }
}
