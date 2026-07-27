//
//  AppEnvironment.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 7/24/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation

enum AppEnvironment {

    case debug

    case testFlight

    case production

    static var current: AppEnvironment {
        #if DEBUG || targetEnvironment(simulator)
        return .debug
        #else
        // Development and TestFlight builds use a sandbox receipt, App Store builds don't.
        if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
            return .testFlight
        }

        return .production
        #endif
    }

    static var isProduction: Bool {
        current == .production
    }
}
