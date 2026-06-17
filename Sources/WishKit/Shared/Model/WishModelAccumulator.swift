//
//  WishModelAccumulator.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import WishKitShared

struct WishModelAccumulator {
    var pending: [WishResponse] = []
    var approved: [WishResponse] = []
    var completed: [WishResponse] = []
    var inReview: [WishResponse] = []
    var planned: [WishResponse] = []
    var inProgress: [WishResponse] = []
}
