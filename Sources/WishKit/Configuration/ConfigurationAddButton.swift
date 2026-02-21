//
//  Config+AddButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/25/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

public struct ConfigurationAddButton {

    public var display: ConfigurationDisplay = .show

    public var textColor = ThemeScheme(light: .black, dark: .white)

    public var bottomPadding: ConfigurationAddButtonPadding

    public var location: ConfigurationAddButtonLocation = .floating

    init(bottomPadding: ConfigurationAddButtonPadding = .small) {
        self.bottomPadding = bottomPadding
    }
}
