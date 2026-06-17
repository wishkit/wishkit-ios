//
//  SwiftUIView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/14/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension Date {

    /// Locale-aware numeric date with two-digit month and day (e.g. "06/07/2026" in en-US, "07.06.2026" in de-DE, "2026/06/07" in ja-JP).
    func wkFormatted() -> String {
        formatted(
            Date.FormatStyle(date: .numeric)
                .month(.twoDigits)
                .day(.twoDigits)
        )
    }
}
