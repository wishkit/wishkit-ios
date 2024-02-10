//
//  List+Compat.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/28/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func scrollContentBackgroundCompat(_ visibility: Compatability.Visibility) -> some View {
        if #available(macOS 13.0, iOS 16, visionOS 1, *) {
            switch visibility {
            case .automatic:
                self.scrollContentBackground(.automatic)
            case .visible:
                self.scrollContentBackground(.visible)
            case .hidden:
                self.scrollContentBackground(.hidden)
            }
        }
    }

    @ViewBuilder
    func scrollIndicatorsCompat(_ visibility: Compatability.Visibility) -> some View {
        if #available(macOS 13.0, iOS 16, visionOS 1, *) {
            switch visibility {
            case .automatic:
                self.scrollIndicators(.automatic)
            case .visible:
                self.scrollIndicators(.visible)
            case .hidden:
                self.scrollIndicators(.hidden)
            }
        }
    }
}
