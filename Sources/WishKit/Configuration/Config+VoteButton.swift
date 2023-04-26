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
        public var tintColor: Color = Color.white
        #elseif canImport(UIKit)
        public var tintColor: UIColor = .label
        #endif
    }
}
