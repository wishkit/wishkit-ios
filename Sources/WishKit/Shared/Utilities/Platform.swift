//
//  Platform.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 7/19/26.

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
