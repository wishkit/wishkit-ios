//
//  MockData.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import WishKitShared
import Foundation

struct MockData {
    static let wishlist = [
        createWish("Transformation Challenge", "It would be awesome to be able to take a picture after every workout and after 30 days it creates a video out of them.")
    ]

    static func createWish(_ title: String, _ description: String) -> WishResponse {
        WishResponse(
            id: UUID(),
            userUUID: UUID(),
            title: title,
            description: description,
            state: .pending,
            votingUsers: []
        )
    }
}
