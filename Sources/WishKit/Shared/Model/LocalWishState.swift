//
//  LocalWishState.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

enum LocalWishState: Hashable, Identifiable {

    case all

    case library(WishState)

    var id: String { description }

    var description: String {
        switch self {
        case .all:
            return "All"
        case .library(let wishState):
            return wishState.description
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}
