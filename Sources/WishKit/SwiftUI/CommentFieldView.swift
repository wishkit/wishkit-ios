//
//  SwiftUIView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/14/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

struct CommentFieldView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @Binding
    private var textFieldValue: String

    @Binding
    private var isLoading: Bool

    private let submitAction: () async throws -> ()

    init(
        _ textFieldValue: Binding<String>,
        isLoading: Binding<Bool>,
        submitAction: @escaping () async throws -> ()
    ) {
        self._textFieldValue = textFieldValue
        self._isLoading = isLoading
        self.submitAction = submitAction
    }

    var body: some View {
        ZStack {
            TextField(WishKit.config.localization.writeAComment, text: $textFieldValue)
                .font(.footnote)
                .padding([.top, .leading, .bottom], 15)
                .padding([.trailing], 40)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            HStack {
                Spacer()
                if isLoading {
                    ProgressView()
                        .padding(10)
                } else {
                    Button(action: { Task { try await submitAction() } }) {
                        Image(systemName: "paperplane.fill")
                            .padding(10)
                    }
                    .foregroundColor(WishKit.theme.primaryColor)
                    .disabled(textFieldValue.replacingOccurrences(of: " ", with: "").isEmpty)
                }
            }
        }
    }
}

extension CommentFieldView {
    var backgroundColor: Color {
        switch colorScheme {
        case .light:

            if let color = WishKit.theme.secondaryColor {
                return color.light
            }

            return PrivateTheme.elementBackgroundColor.light
        case .dark:
            if let color = WishKit.theme.secondaryColor {
                return color.dark
            }

            return PrivateTheme.elementBackgroundColor.dark
        }
    }
}
