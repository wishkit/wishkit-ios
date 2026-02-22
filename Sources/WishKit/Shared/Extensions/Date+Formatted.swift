//
//  SwiftUIView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/14/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension Date {

    /// Returns date of August 10, 2023 formatted as: 08/10/23
    func wkFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: self)
    }
}
