//
//  PrivateFeedbackApi.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/6/24.
//  Copyright © 2024 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

struct PrivateFeedbackApi: RequestCreatable {

    private static let baseUrl = ProjectSettings.apiUrl

    private static let endpoint = URL(string: "\(baseUrl)/private-feedback")

    // MARK: - URLRequests

    private static func createPrivateFeedback(_ createRequest: CreatePrivateFeedbackRequest) -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("create")
        return createAuthedPOSTReuqest(to: url, with: createRequest)
    }

    // MARK: - Api Requests

    static func createPrivateFeedback(createRequest: CreatePrivateFeedbackRequest) async -> ApiResult<CreatePrivateFeedbackResponse, ApiError> {

        guard let request = createPrivateFeedback(createRequest) else {
            return .failure(ApiError(reason: .couldNotCreateRequest))
        }

        return await Api.send(request: request)
    }
}
