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
    private var isButtonDisabled = false

    private var completion: () -> ()

    init(completion: @escaping () -> (), title: String = "", description: String = "") {
        self.completion = completion
        self.wishTitle = title
        self.wishDescription = description
    }

    private func createWishAction() {
        isButtonDisabled = true
        let request = CreateWishRequest(title: wishTitle, description: wishDescription)
        WishApi.createWish(createRequest: request) { _ in
            isButtonDisabled = false
            completion()
        }

        // Call wish api to create wish
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

            Button(action: createWishAction) {
                Text("Save")
                    .frame(width: 100, height: 30)
                    .background(WishKit.theme.primaryColor)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
            }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 100, height: 30)
                .background(WishKit.theme.primaryColor)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
                .shadow(color: .black.opacity(0.33), radius: 5, x: 0, y: 5)
                .disabled(isButtonDisabled)
        }
    }
}
