//
//  View+Shadow.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/15/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension View {
    func wkShadow() -> some View {
        if WishKit.config.dropShadow == .show {
            return AnyView(self.shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0))
        } else {
            return AnyView(self)
        }
    }
}
