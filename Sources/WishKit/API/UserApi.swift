//
//  UserApi.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

struct UserApi: RequestCreatable {

    private static let baseUrl = "\(ProjectSettings.apiUrl)"

    private static var endpoint = URL(string: "\(baseUrl)/user")

    // MARK: - URLRequests

    private static func updateUser(_ userRequest: UserRequest) -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("update")
        return createAuthedPOSTReuqest(to: url, with: userRequest)
    }

    static func updateUser(userRequest: UserRequest) async -> ApiResult<UserResponse, ApiError> {

        guard let request = updateUser(userRequest) else {
            return .failure(ApiError(reason: .couldNotCreateRequest))
        }

        return await Api.send(request: request)
    }
}
