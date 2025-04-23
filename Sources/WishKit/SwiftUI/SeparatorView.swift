//
//  SeparatorView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/12/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct SeparatorView: View {
    var textColor: Color {
        switch colorScheme {
        case .light:

            if let color = WishKit.theme.textColor {
                return color.light
            }

            return .black
        case .dark:
            if let color = WishKit.theme.textColor {
                return color.dark
            }

            return .white
        @unknown default:
            if let color = WishKit.theme.textColor {
                return color.light
            }

            return .black
        }
    }
    var body: some View {
        HStack(alignment: .center) {
            VStack { Divider() }
            Text(WishKit.config.localization.comments.uppercased()).font(.caption2).foregroundColor(textColor)
            VStack { Divider() }
        }
    }
}
