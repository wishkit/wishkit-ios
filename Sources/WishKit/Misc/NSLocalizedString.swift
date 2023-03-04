//
//  NSLocalizedString.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/4/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, bundle: .module, comment: "")
}

