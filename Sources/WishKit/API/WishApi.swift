//
//  WishApi.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

struct WishApi: RequestCreatable {

    private static let baseUrl = "\(ProjectSettings.apiUrl)"

    private static var endpoint = URL(string: "\(baseUrl)/wish")

    // MARK: - URLRequests

    private static func makeFetchWishListRequest() -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("list")
        return createAuthedGETReuqest(to: url)
    }

    private static func makeCreateWishRequest(_ createRequest: CreateWishRequest) -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("create")
        return createAuthedPOSTReuqest(to: url, with: createRequest)
    }

    private static func makeVoteWishRequest(_ voteRequest: VoteWishRequest) -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("vote")
        return createAuthedPOSTReuqest(to: url, with: voteRequest)
    }

    // MARK: - Api Requests

    static func fetchWishList() async -> ApiResult<ListWishResponse, ApiError> {
        guard let request = makeFetchWishListRequest() else {
            return .failure(ApiError(reason: .couldNotCreateRequest))
        }

        return await Api.send(request: request)
    }

    static func fetchWishList(
        completionHandler: @escaping (ApiResult<ListWishResponse, ApiError>) -> Void
    ) {
        Task {
            let result = await fetchWishList()
            completionHandler(result)
        }
    }

    static func createWish(createRequest: CreateWishRequest) async -> ApiResult<CreateWishResponse, ApiError> {
        guard let request = makeCreateWishRequest(createRequest) else {
            return .failure(ApiError(reason: .couldNotCreateRequest))
        }

        return await Api.send(request: request)
    }

    static func createWish(
        createRequest: CreateWishRequest,
        completionHandler: @escaping (ApiResult<CreateWishResponse, ApiError>) -> Void
    ) {
        Task {
            let result = await createWish(createRequest: createRequest)
            completionHandler(result)
        }
    }

    static func voteWish(voteRequest: VoteWishRequest) async -> ApiResult<VoteWishResponse, ApiError> {
        guard let request = makeVoteWishRequest(voteRequest) else {
            return .failure(ApiError(reason: .couldNotCreateRequest))
        }

        return await Api.send(request: request)
    }

    static func voteWish(
        voteRequest: VoteWishRequest,
        completionHandler: @escaping (ApiResult<VoteWishResponse, ApiError>) -> Void
    ) {
        Task {
            let result = await voteWish(voteRequest: voteRequest)
            completionHandler(result)
        }
    }
}
