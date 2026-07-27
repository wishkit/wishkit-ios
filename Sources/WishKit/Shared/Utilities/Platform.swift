//
//  Platform.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 7/19/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation

enum Platform {
    static var name: String {
        #if os(iOS)
        return "ios"
        #elseif os(macOS)
        return "macos"
        #elseif os(visionOS)
        return "visionos"
        #elseif os(watchOS)
        return "watchos"
        #elseif os(tvOS)
        return "tvos"
        #else
        return "unknown"
        #endif
    }
}
