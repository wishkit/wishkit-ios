//
//  Config+AddButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/25/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

extension Configuration {
    public struct AddButton {

        #if os(macOS)
        @available(*, deprecated, message: "Use `textColor` instead.")
        public var tintColor: Color = Color.white
        #elseif canImport(UIKit)
        @available(*, deprecated, message: "Use `textColor` instead.")
        public var tintColor: UIColor = .label
        #endif

        public var textColor = Theme.Scheme(light: .black, dark: .white)

        public var bottomPadding: Padding

        init(bottomPadding: Padding = .small) {
            self.bottomPadding = bottomPadding
        }
    }
}

extension Configuration.AddButton {
    public enum Padding {
        case small
        case medium
        case large
    }
}
