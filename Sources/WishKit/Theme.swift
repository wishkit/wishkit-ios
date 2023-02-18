//
//  Theme.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/18/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit

extension WishKit {
    public struct Theme {

        let primaryColor: UIColor

        public init(primaryColor: UIColor) {
            self.primaryColor = primaryColor
        }

        static func `default`() -> Theme {
            return Theme(primaryColor: .systemGreen)
        }
    }
}
