//
//  WishModelTest.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/15/24.
//  Copyright © 2024 Martin Lasek. All rights reserved.
//

import XCTest

@testable import WishKit

class WishModelTest: XCTestCase {

    let wishModel = WishModel(wishApi: MockWishApi())

    func testApprovedWishList() {
        XCTAssertTrue(wishModel.approvedWishlist.isEmpty)
    }

    func testImplementedWishList() {
        XCTAssertTrue(wishModel.implementedWishlist.isEmpty)
    }

    func testFetchWishList() async throws {

        // Uses mock data. Zero delay. Just potentially slower thread than assert.
        await wishModel.fetchList()

        try await Task.sleep(for: .seconds(0.2))

        XCTAssertEqual(wishModel.approvedWishlist.count, 1)
        XCTAssertEqual(wishModel.implementedWishlist.count, 1)
    }

    func testFilteringCorrectWishesIntoApprovedAndImplementedLists() async throws {

        // Uses mock data. Zero delay. Just potentially slower thread than assert.
        await wishModel.fetchList()

        try await Task.sleep(for: .seconds(0.2))
        
        let approvedWish = wishModel.approvedWishlist[0]
        XCTAssertEqual(approvedWish.title, MockData.approvedWish.title)

        let implementedWish = wishModel.implementedWishlist[0]
        XCTAssertEqual(implementedWish.title, MockData.implementedWish.title)
    }
}

