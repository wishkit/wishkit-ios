//
//  AddButton+macOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 5/25/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(macOS)
import SwiftUI

struct AddButton: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @State
    private var showingSheet = false

    private let size: CGSize

    private let buttonAction: () -> ()

    init(size: CGSize = CGSize(width: 45, height: 45), buttonAction: (() -> ())? = nil) {
        self.size = size
        self.buttonAction = buttonAction ?? { }
    }

    var body: some View {
        Button(action: buttonAction) {
            Image(systemName: "plus")
                .frame(width: size.width, height: size.height)
                .foregroundColor(.white)
                .background(WishKit.theme.primaryColor)
                .clipShape(.circle)
        }
        .buttonStyle(.plain)
        .buttonStyle(.roundButtonStyle)
        .frame(width: size.width, height: size.height)
        .background(WishKit.theme.primaryColor)
        .clipShape(.circle)
        .shadow(color: .black.opacity(0.33), radius: 5, x: 0, y: 5)
    }
}

extension ButtonStyle where Self == RoundButtonStyle {
    static var roundButtonStyle: RoundButtonStyle {
        RoundButtonStyle()
    }
}
#endif
