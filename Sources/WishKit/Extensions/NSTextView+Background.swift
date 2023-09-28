//
//  NSTextView+Background.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/28/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

#if os(macOS)
/// Removes default background color and allows custom color for TextEditor
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}
#endif
