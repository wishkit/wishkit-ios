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

    func testFetchWishList() async {
        
        // Uses mock data. Zero delay. Just potentially slower thread than assert.
        await wishModel.fetchList()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.wishModel.approvedWishlist.count, 1)
            XCTAssertEqual(self.wishModel.implementedWishlist.count, 1)
        }
    }
}

