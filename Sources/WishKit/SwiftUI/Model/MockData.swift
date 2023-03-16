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
    static var wishlist: [WishResponse] {
        let wishlist = [
            createWish("📸 Transformation Challenge", "It would be awesome to be able to take a picture after every workout and after 30 days it creates a video out of them."),
            createWish("🎥 Exercise Video Example.", "When doing an exercise it would be great if I could see a video example that shows me how to do it properly"),
            createWish("Health App Connection.", "If this app would also let Health App know about your exercises then this would be awesome!"),
            createWish("Browser exercise list", "I would like to see exercises in a list and be able to chose from then when creating my workouts instead of coming up with them myself."),
            createWish("📈 Statistics of my workout", "Seeing a chart that displays how disciplined I was this week and also how many calories I have burned would be great."),
            createWish("⌚️ Apple Watch App", "Having the app also on the Apple Watch would be super convenient. Especially when I want to pause a workout or so.")
        ]

        var votes = 123
        return wishlist.map({ wish in
            var shadowWish = wish
            var ul = [UserResponse(uuid: UUID())]
            for _ in 1...votes {
                ul.append(UserResponse(uuid: UUID()))
            }

            votes -= Int.random(in: 1...7)
            return WishResponse(
                id: shadowWish.id,
                userUUID: shadowWish.userUUID,
                title: shadowWish.title,
                description: shadowWish.description,
                state: .approved,
                votingUsers: ul
            )
        })
    }

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
