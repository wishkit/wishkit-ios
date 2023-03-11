//
//  CreateWishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

struct CreateWishView: View {

    @State
    private var wishTitle: String

    @State
    private var wishDescription: String

    @State
    private var isButtonLoading: Bool? = false

    private var completion: () -> ()

    init(completion: @escaping () -> (), title: String = "", description: String = "") {
        self.completion = completion
        self.wishTitle = title
        self.wishDescription = description
    }

    private func createWishAction() {
        isButtonLoading = true
        let request = CreateWishRequest(title: wishTitle, description: wishDescription)
        WishApi.createWish(createRequest: request) { _ in
            isButtonLoading = false
            completion()
        }
    }

    var body: some View {
        VStack {
            TextField("Title of the wish..", text: $wishTitle)
                .padding(EdgeInsets(top: 15, leading: 30, bottom: 10, trailing: 30))
                .textFieldStyle(.roundedBorder)

            TextField("Description of the wish..", text: $wishDescription)
                .lineLimit(8)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 15, leading: 30, bottom: 10, trailing: 30))

            WKButton(text: "Save", action: createWishAction, isLoading: $isButtonLoading)
        }
    }
}
