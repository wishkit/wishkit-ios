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

    private static let baseUrl = "\(ProjectSettings.apiUrl)"

    private static var endpoint = URL(string: "\(baseUrl)/wish")

    // MARK: - URLRequests

    private static func createPrivateFeedback(_ createRequest: CreateWishRequest) -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("create")
        return createAuthedPOSTReuqest(to: url, with: createRequest)
    }

    // MARK: - Api Requests

    static func createWish(
        createRequest: CreatePrivateFeedbackRequest,
        completionHandler: @escaping (ApiResult<CreateWishResponse, ApiError>) -> Void
    ) {

        guard let request = createWish(createRequest) else {
            completionHandler(.failure(ApiError(reason: .couldNotCreateRequest)))
            return
        }

        Api.send(request: request, completionHandler: completionHandler)
    }
}
