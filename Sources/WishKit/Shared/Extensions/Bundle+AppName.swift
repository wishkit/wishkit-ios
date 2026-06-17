//
//  Bundle+APpName.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/30/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

extension Bundle {
    var displayName: String? {
        let displayName = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let name = object(forInfoDictionaryKey: "CFBundleName") as? String
        return displayName ?? name ?? nil
    }
}
