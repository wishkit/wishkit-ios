//
//  UUIDManagerTest.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/15/24.
//  Copyright © 2024 Martin Lasek. All rights reserved.
//

import XCTest

@testable import WishKit

class UUIDManagerTest: XCTestCase {

    func testGetUUID() {
        let uuid = UUIDManager.getUUID()

        XCTAssertNotNil(uuid)

        let uuidAgain = UUIDManager.getUUID()

        XCTAssertEqual(uuid, uuidAgain)
    }

    func testDeleteUUID() {
        let uuid = UUIDManager.getUUID()

        XCTAssertNotNil(uuid)

        UUIDManager.deleteUUID()

        let uuidNew = UUIDManager.getUUID()

        XCTAssertNotEqual(uuid, uuidNew)
    }
}
