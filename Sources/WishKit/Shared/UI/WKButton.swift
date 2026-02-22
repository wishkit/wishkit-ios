//
//  WKButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct WKButton: View {

    @Environment(\.colorScheme)
    var colorScheme

    private let text: String

    private let action: () -> ()

    private let style: WKButtonStyle

    private let size: CGSize

    @Binding
    var isLoading: Bool

    public init(
        text: String,
        action: @escaping () -> (),
        style: WKButtonStyle = .primary,
        isLoading: Binding<Bool> = .constant(false),
        size: CGSize = CGSize(width: 100, height: 30)
    ) {
        self.text = text
        self.action = action
        self.style = style
        self._isLoading = isLoading
        self.size = size
    }

    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .scaleEffect(0.5)
            } else {
                Text(text)
                    .foregroundColor(textColor)
                    .frame(width: size.width, height: size.height)
                    .background(color(for: style))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: size.width, height: size.height)
        .background(color(for: style))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .disabled(isLoading)
    }

    func color(for style: WKButtonStyle) -> Color {
        switch style {
        case .primary:
            return WishKit.theme.primaryColor
        case .secondary:
            return backgroundColor
        }
    }

    var textColor: Color {
        switch colorScheme {
        case .light:
            return WishKit.config.buttons.saveButton.textColor.light
        case .dark:
            return WishKit.config.buttons.saveButton.textColor.dark
        @unknown default:
            return WishKit.config.buttons.saveButton.textColor.light
        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            return PrivateTheme.elementBackgroundColor.light
        case .dark:
            return PrivateTheme.elementBackgroundColor.dark
        @unknown default:
            return PrivateTheme.elementBackgroundColor.light
        }
    }
}
