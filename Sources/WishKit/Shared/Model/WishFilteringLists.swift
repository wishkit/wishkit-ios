//
//  WishFilteringLists.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import WishKitShared

struct WishFilteringLists {
    let all: [WishResponse]
    let pending: [WishResponse]
    let approved: [WishResponse]
    let completed: [WishResponse]
}
