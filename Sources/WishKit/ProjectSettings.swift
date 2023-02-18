//
//  ProjectSettings.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

struct ProjectSettings {
    static var apiUrl = "https://wishkit.io/api"

    enum Environment {
        case simulator
        case testFlight
        case appStore
    }

    struct Config {
        private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

        static var isSimulator: Bool {
            #if targetEnvironment(simulator)
            return true
            #else
            return false
            #endif
        }

        static var isProduction: Bool {
            if isSimulator || isTestFlight {
                return false
            }

            return true
        }

        static var environment: Environment {
            if isSimulator {
                return .simulator
            }

            if isTestFlight {
                return .testFlight
            }

            return .appStore
        }
    }
}
