//
//  UILabel+Init.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(
        _ text: String? = nil,
        color: UIColor = .label,
        font: UIFont = .systemFont(ofSize: UIFont.labelFontSize),
        alignment: NSTextAlignment = .left,
        lineCount: Int = 1
    ) {
        self.init()
        self.text = text
        self.textColor = color
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = lineCount
    }
}
