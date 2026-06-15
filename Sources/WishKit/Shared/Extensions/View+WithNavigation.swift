//
//  View+WithNavigation.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/15/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(iOS) || os(tvOS)
import SwiftUI

extension View {
    public func withNavigation() -> some View {
        NavigationStack {
            self
        }
    }
}
#endif
