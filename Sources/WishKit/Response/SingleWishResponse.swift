//
//  SingleWishResponse.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

struct SingleWishResponse: Codable {

    let id: Int

    let userUUID: UUID

    let title: String

    let description: String

    let state: State

    let votingUsers: [SingleUserResponse]

    enum State: String, Codable {
        case pending
        case approved
        case implemented
        case rejected
    }
}
