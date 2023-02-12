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

    private static var endpoint: URL? {
        return URL(string: "\(baseUrl)/wish")
    }

    // MARK: - URLRequests

    private static func fetchWishList() -> URLRequest? {
        guard var url = endpoint else { return nil }
        url.appendPathComponent("list")
        return createGETRequest(to: url)
    }

//    private static func createWish(_ createRequest: CreateWishRequest) -> URLRequest? {
//        guard var url = endpoint else { return nil }
//        url.appendPathComponent("create")
//        return createAuthedPOSTReuqest(to: url, with: createRequest)
//    }
//
//    private static func voteWish(_ voteRequest: VoteWishRequest) -> URLRequest? {
//        guard var url = endpoint else { return nil }
//        url.appendPathComponent("\(voteRequest.wishId)/vote")
//        return createAuthedPOSTReuqest(to: url, with: voteRequest)
//    }

    // MARK: - Api Requests

    static func fetchWishList(
        completionHandler: @escaping (Result<ListWishResponse, ApiError.Kind>) -> Void
    ) {
        guard let request = fetchWishList() else {
            completionHandler(.failure(.couldNotCreatePOSTRequest))
            return
        }

        Api.send(request: request) { result in completionHandler(result) }
    }

//    static func createWish(
//        createRequest: CreateWishRequest,
//        completionHandler: @escaping (Result<CreateWishResponse, ApiError.Kind>) -> Void
//    ) {
//
//        guard let request = createWish(createRequest) else {
//            completionHandler(.failure(.couldNotCreatePOSTRequest))
//            return
//        }
//
//        Api.send(request: request) { result in completionHandler(result) }
//    }

//    static func voteWish(
//        voteRequest: VoteWishRequest,
//        completionHandler: @escaping (Result<SingleWishResponse, ApiError.Kind>) -> Void
//    ) {
//
//        guard let request = voteWish(voteRequest) else {
//            completionHandler(.failure(.couldNotCreatePOSTRequest))
//            return
//        }
//
//        Api.send(request: request) { result in completionHandler(result) }
//    }
}
