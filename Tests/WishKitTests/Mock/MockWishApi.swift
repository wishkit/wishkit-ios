//
//  MockWishApi.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/15/24.
//  Copyright © 2024 Martin Lasek. All rights reserved.
//

import XCTest

@testable import WishKit
@testable import WishKitShared

struct MockWishApi: WishApiProvider {
    
    func fetchWishList(completion: @escaping (Result<ListWishResponse, ApiError>) -> Void) {
        let list = [
            MockData.pendingWish,
            MockData.approvedWish,
            MockData.implementedWish,
            MockData.rejectedWish
        ]

        completion(.success(ListWishResponse(list: list, shouldShowWatermark: true)))
    }
    
    func createWish(createRequest: CreateWishRequest, completion: @escaping (Result<CreateWishResponse, ApiError>) -> Void) {
        fatalError()
    }
    
    func voteWish(voteRequest: VoteWishRequest, completion: @escaping (Result<VoteWishResponse, ApiError>) -> Void) {
        fatalError()
    }
}
