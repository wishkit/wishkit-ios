//
//  Config+VoteButton.swift
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
    public struct VoteButton {

        #if os(macOS)
        @available(*, deprecated, message: "Use `arrowColor` instead.")
        public var tintColor: Color = .white
        #elseif canImport(UIKit)
        @available(*, deprecated, message: "Use `arrowColor` instead.")
        public var tintColor: UIColor = .label
        #endif

        public var arrowColor = Theme.Scheme(light: .gray, dark: .gray)

        public var textColor = Theme.Scheme(light: .black, dark: .white)
    }
}
