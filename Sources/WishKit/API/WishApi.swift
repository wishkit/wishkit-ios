//
//  WishApi.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

protocol WishApiProvider {
    static func fetchWishList(completion: @escaping (Result<ListWishResponse, ApiError>) -> Void)

    static func createWish(
        createRequest: CreateWishRequest,
        completion: @escaping (Result<CreateWishResponse, ApiError>) -> Void
    )

    static func voteWish(
        voteRequest: VoteWishRequest,
        completion: @escaping (Result<VoteWishResponse, ApiError>) -> Void
    )
}

struct WishApi: RequestCreatable {

    private static let baseUrl = ProjectSettings.apiUrl

    private static let endpoint = URL(string: "\(baseUrl)/wish")

    // MARK: - URLRequests

    private static func fetchWishList() -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("list")
        return createAuthedGETRequest(to: url)
    }

    private static func createWish(_ createRequest: CreateWishRequest) -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("create")
        return createAuthedPOSTRequest(to: url, with: createRequest)
    }

    private static func voteWish(_ voteRequest: VoteWishRequest) -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("vote")
        return createAuthedPOSTRequest(to: url, with: voteRequest)
    }
}

// MARK: - WishApiProvider

extension WishApi: WishApiProvider {

    static func fetchWishList(
        completion: @escaping (Result<ListWishResponse, ApiError>) -> Void
    ) {
        guard let request = fetchWishList() else {
            completion(.failure(ApiError(reason: .couldNotCreateRequest)))
            return
        }

        Api.send(request: request, completionHandler: completion)
    }

    static func createWish(
        createRequest: CreateWishRequest,
        completion: @escaping (Result<CreateWishResponse, ApiError>) -> Void
    ) {

        guard let request = createWish(createRequest) else {
            completion(.failure(ApiError(reason: .couldNotCreateRequest)))
            return
        }

        Api.send(request: request, completionHandler: completion)
    }

    static func voteWish(
        voteRequest: VoteWishRequest,
        completion: @escaping (Result<VoteWishResponse, ApiError>) -> Void
    ) {

        guard let request = voteWish(voteRequest) else {
            completion(.failure(ApiError(reason: .couldNotCreateRequest)))
            return
        }

        Api.send(request: request, completionHandler: completion)
    }
}
