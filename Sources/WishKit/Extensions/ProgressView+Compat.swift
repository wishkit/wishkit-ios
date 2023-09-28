//
//  ProgressView+Compat.swift
//
//
//  Created by Martin Lasek on 9/28/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension ProgressView {

    @ViewBuilder
    func controlSizeCompat(_ controlSize: ControlSizeCompat) -> some View {
        if #available(iOS 15, *) {
            switch controlSize {
            case .mini:
                self.controlSize(.mini)
            case .small:
                self.controlSize(.small)
            case .regular:
                self.controlSize(.regular)
            case .large:
                self.controlSize(.large)
            }
        } else {
            self
        }
    }

    enum ControlSizeCompat {
        case mini
        case small
        case regular
        case large
    }
}
