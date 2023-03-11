//
//  WKButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct WKButton: View {

    enum ButtonStyle {
        case primary
        case secondary

        var color: Color {
            switch self {
            case .primary:
                return WishKit.theme.primaryColor
            case .secondary:
                return .gray
            }
        }
    }

    private let text: String

    private let action: () -> ()

    private let style: ButtonStyle

    @Binding
    var isLoading: Bool?

    public init(
        text: String,
        action: @escaping () -> (),
        style: ButtonStyle = .primary,
        isLoading: Binding<Bool?> = Binding.constant(nil)
    ) {
        self.text = text
        self.action = action
        self.style = style
        _isLoading = isLoading
    }

    var body: some View {
        Button(action: action) {
            if isLoading ?? false {
                ProgressView()
                    .scaleEffect(0.5)
            } else {
                Text(text)
                    .frame(width: 100, height: 30)
                    .background(style.color)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
            }
        }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 100, height: 30)
            .background(style.color)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .disabled(isLoading ?? false)
    }
}
