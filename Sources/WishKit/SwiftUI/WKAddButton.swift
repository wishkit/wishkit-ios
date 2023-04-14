//
//  WKAddButton.swift
//  
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct WKAddButton: View {

    @State
    var showingSheet = false

    var buttonAction: () -> ()

    var body: some View {
        Button(action: buttonAction) {
            Image(systemName: "plus")
                .frame(width: 45, height: 45)
                .foregroundColor(.white)
                .background(WishKit.theme.primaryColor)
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
        .buttonStyle(RoundButtonStyle())
        .frame(width: 45, height: 45)
        .background(WishKit.theme.primaryColor)
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.33), radius: 5, x: 0, y: 5)
        .sheet(isPresented: $showingSheet) {
            Text(WishKit.configuration.localization.createWish)
        }
    }

    init(buttonAction: @escaping () -> ()) {
        self.buttonAction = buttonAction
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
