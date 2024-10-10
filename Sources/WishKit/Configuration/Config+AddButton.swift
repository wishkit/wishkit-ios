//
//  Config+AddButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/25/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension Configuration {
    
    public struct AddButton {
        
        public var display: Display = .show

        public var textColor = Theme.Scheme(light: .black, dark: .white)

        public var bottomPadding: Padding
        
        public var location: Location = .floating

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
    
    public enum Location {
        case floating
        case navigationBar
    }
}
