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

    /// Groups a user's own pending feedback together with all active feedback (approved, in review, planned, in progress).
    case open

    /// Groups completed and implemented feedback.
    case closed

    case library(WishState)

    var id: String { description }

    var description: String {
        switch self {
        case .all:
            return WishKit.config.localization.all
        case .open:
            return WishKit.config.localization.open
        case .closed:
            return WishKit.config.localization.closed
        case .library(let wishState):
            return wishState.description
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}
