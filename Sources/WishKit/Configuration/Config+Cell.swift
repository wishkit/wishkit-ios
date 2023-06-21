//
//  Config+Cell.swift
//  
//
//  Created by Martin Lasek on 6/20/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

extension Configuration {
    public struct Cell {
        #if os(macOS)
        public var textColor: Color = Color.white
        #elseif canImport(UIKit)
        public var textColor: UIColor = .label
        #endif
    }
}
