//
//  DetailWishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct DetailWishView: View {

    @Environment (\.presentationMode)
    var presentationMode

    private var title: String

    private var description: String

    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))

            VStack {
                Text(title)
                Text(description)
                Button("Close") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                .interactiveDismissDisabled()
            }
        }
    }
}
