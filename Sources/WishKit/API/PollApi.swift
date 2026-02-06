//
//  PollApi.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/5/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

struct PollApi: RequestCreatable {

    private static let baseUrl = "\(ProjectSettings.apiUrl)"

    private static var endpoint = URL(string: "\(baseUrl)/poll")

    // MARK: - URLRequests

    // MARK: - Fetch Active
    
    private static func getFetchActiveRequest() -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("active")
        return createAuthedGETReuqest(to: url)
    }
    
    static func fetchActive() async -> ApiResult<ActivePollResponse, ApiError> {
        guard let fetchRequest = getFetchActiveRequest() else {
            return .failure(ApiError(reason: .couldNotCreateRequest))
        }
        
        return await Api.send(request: fetchRequest)
    }
}

// MARK: - Request and Response

struct ActivePollResponse: Codable {
    let activePoll: PollResponse?
}

struct ListPollResponse: Codable {
    let polls: [PollResponse]
}

struct PollAnswerResponse: Codable {
    let id: UUID
    let title: String
    let count: Int
}

struct PollResponse: Codable {
    let id: UUID
    let title: String
    let status: PollStatus
    let projectId: UUID
    let closesAt: Date?
    let answers: [PollAnswerResponse]
}

enum PollStatus: String, Codable {

    case active

    case closed
}
