//
//  CloseButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 1/19/24.
//  Copyright © 2024 Martin Lasek. All rights reserved.
//

import SwiftUI

struct CloseButton: View {

    private let closeAction: () -> Void
    
    init(closeAction: @escaping () -> Void) {
        self.closeAction = closeAction
    }
    
    var body: some View {
        #if os(macOS) || os(visionOS)
        Button(action: closeAction, label: { Image(systemName: "x.circle.fill") })
            .buttonStyle(PlainButtonStyle())
            .foregroundStyle(Color.secondary)
            .padding(.top, getButtonPadding().0)
            .padding(.trailing, getButtonPadding().1)
        #else
        Text("Should never be rendered since close button should not be used on iOS").opacity(0)
        #endif
    }

    private func getButtonPadding() -> (CGFloat, CGFloat) {
        #if os(visionOS)
            return (15, 25)
        #else
            return (15, 15)
        #endif
    }
}
