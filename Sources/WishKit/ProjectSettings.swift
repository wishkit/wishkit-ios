//
//  ProjectSettings.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

struct ProjectSettings {

    static let apiUrl = {
        let wishKitUrl = ProcessInfo.processInfo.environment["wishkit-url"]
        return wishKitUrl ?? "https://www.wishkit.io/api"
    }()

    static let sdkVersion = "4.1.1"
}
