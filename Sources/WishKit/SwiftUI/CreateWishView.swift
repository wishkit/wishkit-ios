//
//  CreateWishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import Combine
import WishKitShared

// Removes default background color and allows custom color for TextEditor

#if os(macOS)
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}

struct CreateWishView: View {

    @Environment (\.presentationMode)
    var presentationMode

    @Environment(\.colorScheme)
    var colorScheme

    @State
    private var title: String = ""

    @State
    private var description: String = ""

    @State
    private var isButtonLoading: Bool? = false

    @State
    private var showAlert: Bool = false

    private var completion: () -> ()

    init(completion: @escaping () -> ()) {
        self.completion = completion
    }

    private func createWishAction() {
        if title.isEmpty || description.isEmpty {
            showAlert = true
            return
        }

        isButtonLoading = true
        let request = CreateWishRequest(title: title, description: description)
        WishApi.createWish(createRequest: request) { _ in
            isButtonLoading = false
            completion()
        }
    }

    func keepTitleAndTextWithinLimit() {
        let titleLimit = 50
        let descriptionLimit = 500

        if title.count > titleLimit {
            title = String(title.prefix(titleLimit))
        }

        if description.count > descriptionLimit {
            description = String(description.prefix(descriptionLimit))
        }


    }

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Title")
                        .font(.system(size: 10))
                    Spacer()
                    Text("\(title.count)/50")
                        .font(.system(size: 10))
                }.padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))

                TextField("Title of the wish..", text: $title)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 35)
                    .padding([.horizontal], 10)
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .onReceive(Just(title)) { _ in keepTitleAndTextWithinLimit() }

                HStack {
                    Text("Description")
                        .font(.system(size: 10))
                    Spacer()
                    Text("\(description.count)/500")
                        .font(.system(size: 10))
                }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))

                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(backgroundColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 2, trailing: 15))

                    TextEditor(text: $description)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                        .lineSpacing(3)
                        .onReceive(Just(description)) { _ in keepTitleAndTextWithinLimit() }
                }

            }

            HStack {
                WKButton(text: "Cancel", action: { self.presentationMode.wrappedValue.dismiss() }, style: .secondary)
                .interactiveDismissDisabled()
                WKButton(text: "Save", action: createWishAction, isLoading: $isButtonLoading)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        }.alert(String("Info"), isPresented: $showAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("Title/Description cannot be empty.")
        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            return PrivateTheme.elementBackgroundColor.light
        case .dark:
            return PrivateTheme.elementBackgroundColor.dark
        }
    }
}
#endif
