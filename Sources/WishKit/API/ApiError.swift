//
//  ApiError.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

struct ApiError {
    struct Backend: Codable {
        let error: Bool
        let reason: String
    }

    enum Kind: String, Error {
        // Backend
        case userAlreadyVoted

        case titleAlreadyExists

        case cannotVoteForOwnWish

        // Local
        case couldNotCreatePOSTRequest

        case couldNotCreateGETRequest

        case couldNotCreatePATCHRequest

        case couldNotCreateDELETERequest

        case couldNotDecodeBackendResponse

        case noConnectionToTheServer

        case unKnown

        /// Error that was passed through `NSLocalizedString`.
        var description: String {
            switch self {
            case .userAlreadyVoted:
                return "You can only vote once."
            case .cannotVoteForOwnWish:
                return "You cannot vote for your own wish."
            default:
                return "Oh, something didn't work out.\n(\(self))"
            }
        }
    }
}
