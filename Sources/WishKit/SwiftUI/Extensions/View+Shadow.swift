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
        return self.shadow(color: .black.opacity(1/5), radius: 4, y: 3)
    }
}
