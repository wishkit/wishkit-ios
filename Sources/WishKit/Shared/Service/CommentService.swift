//
//  CommentService.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/14/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

struct CommentService: RequestCreatable {

    private static let baseUrl = "\(ProjectSettings.apiUrl)"

    private static var endpoint = URL(string: "\(baseUrl)/comment")

    // MARK: - URLRequests

    private static func createComment(_ request: CreateCommentRequest) -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("create")
        return createAuthedPOSTRequest(to: url, with: request)
    }

    static func createComment(request: CreateCommentRequest) async -> ApiResult<CommentResponse, ApiError> {

        guard let request = createComment(request) else {
            return .failure(ApiError(reason: .couldNotCreateRequest))
        }

        return await ApiClient.send(request: request)
    }
}

