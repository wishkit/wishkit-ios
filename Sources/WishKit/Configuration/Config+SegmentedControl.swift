//
//  Config+SegmentedControl.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/25/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension Configuration {
    public struct SegmentedControl {

        /// Hides/Shows the segmented control to switch between 'Requested' and 'Implemented'.
        public var display: Display = .show

        public var defaultTextColor = Theme.Scheme(light: .black, dark: .white)

        public var activeTextColor = Theme.Scheme(light: .white, dark: .white)
    }
}
