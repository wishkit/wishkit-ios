//
//  Button+Compat.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/28/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension Button {

    @ViewBuilder
    func listRowSeparatorCompat(_ visibility: Compatability.Visibility) -> some View {
        if #available(macOS 13.0, iOS 15, visionOS 1, *) {
            switch visibility {
            case .automatic:
                self.listRowSeparator(.automatic)
            case .visible:
                self.listRowSeparator(.visible)
            case .hidden:
                self.listRowSeparator(.hidden)
            }
        }
    }
}
