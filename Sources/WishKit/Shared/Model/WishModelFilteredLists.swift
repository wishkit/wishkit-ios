//
//  WishModelFilteredLists.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import WishKitShared

struct WishModelFilteredLists {
    let sortedList: [WishResponse]
    let pending: [WishResponse]
    let approved: [WishResponse]
    let completed: [WishResponse]
    let inReview: [WishResponse]
    let planned: [WishResponse]
    let inProgress: [WishResponse]
}
