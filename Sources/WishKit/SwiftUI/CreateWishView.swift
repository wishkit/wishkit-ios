//
//  CreateWishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct CreateWishView: View {

    @State
    private var wishTitle: String

    @State
    private var wishDescription: String

    init(title: String = "", description: String = "") {
        self.wishTitle = title
        self.wishDescription = description
    }

    var body: some View {
        VStack {
            TextField("Title of the wish..", text: $wishTitle)
                .padding(EdgeInsets(top: 15, leading: 30, bottom: 10, trailing: 30))
                .textFieldStyle(.roundedBorder)

            TextField("Description of the wish..", text: $wishDescription)
                .lineLimit(8)
                .textFieldStyle(PlainTextFieldStyle())
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .background(Color.red)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
        }
    }
}
