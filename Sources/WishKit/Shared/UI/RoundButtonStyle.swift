//
//  RoundButtonStyle.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import SwiftUI

struct RoundButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .white.opacity(0.66) : .white)
            .background(WishKit.theme.primaryColor)
    }
}
