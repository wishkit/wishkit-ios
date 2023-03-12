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
        createWish("Transformation Challenge", "It would be awesome to be able to take a picture after every workout and after 30 days it creates a video out of them."),
        createWish("Toki is so fluffy", "Oh, awesome to be able to after every workout 30 days it creates take a picture and after a video out of them."),
        createWish("Reach for the sky", "Toy Story is Landon's favorite movie."),
        createWish("The Firm", "I haven't seen that one yet. It's on my list now."),
        createWish("TopGun Maverick", "Probably the best film of 2022. A must watch."),
        createWish("Vanilla Sky", "A great movie from the early 2000s that has a unique charm.")
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
