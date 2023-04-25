//
//  Config+AddButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/25/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

extension Configuration {
    public struct AddButton {
        public enum Padding {
            case small
            case medium
            case large
        }

        public var bottomPadding: Padding

        public init(bottomPadding: Padding = .small) {
            self.bottomPadding = bottomPadding
        }
    }
}
