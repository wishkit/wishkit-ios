//
//  CommentFieldView+visionOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/11/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(visionOS)
import SwiftUI
import WishKitShared

struct CommentFieldView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @Binding
    private var textFieldValue: String

    @Binding
    private var isLoading: Bool

    init(
        _ textFieldValue: Binding<String>,
        isLoading: Binding<Bool>,
    ) {
        self._textFieldValue = textFieldValue
        self._isLoading = isLoading
    }

    var body: some View {
        HStack(spacing: 8) {
            TextField(WishKit.config.localization.writeAComment, text: $textFieldValue)
                .textFieldStyle(.plain)
                .font(.footnote)
                .foregroundColor(textColor)
                .disabled(isLoading)
        }
        .padding(.horizontal, 15)
        .frame(height: 44)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
    }
}

extension CommentFieldView {

    var textColor: Color {
        WishKit.theme.textColor?.resolved(for: colorScheme) ?? .primary
    }
}
#endif
