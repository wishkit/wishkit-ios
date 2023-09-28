//
//  AddButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

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
                .frame(width: 45, height: 45)
                .foregroundColor(addButtonTextColor)
                .background(WishKit.theme.primaryColor)
                .clipShape(.circle)
        }
        .buttonStyle(.plain)
        .buttonStyle(RoundButtonStyle())
        .frame(width: size.width, height: size.height)
        .background(WishKit.theme.primaryColor)
        .clipShape(.circle)
        .shadow(color: .black.opacity(0.33), radius: 5, x: 0, y: 5)
        .sheet(isPresented: $showingSheet) {
            Text(WishKit.config.localization.createWish)
        }
    }

    var addButtonTextColor: Color {
        switch colorScheme {
        case .light:
            return WishKit.config.buttons.addButton.textColor.light
        case .dark:
            return WishKit.config.buttons.addButton.textColor.dark
        }
    }
}

struct RoundButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .white.opacity(0.66) : .white)
            .background(WishKit.theme.primaryColor)
    }
}
