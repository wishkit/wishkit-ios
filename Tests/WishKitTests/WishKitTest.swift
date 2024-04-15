//
//  WishKitTest.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//

import XCTest

@testable import WishKit

class WishKitTest: XCTestCase {

    func testApiKeyConfiguration() {
        let apiKey = "642EF81A-6763-490C-904B-DDAA588B0B23"
        
        XCTAssertNotEqual(WishKit.apiKey, apiKey)

        WishKit.configure(with: apiKey)
        
        XCTAssertEqual(WishKit.apiKey, apiKey)
    }

    func testUpdateUserCustomID() {
        let customID = "23"

        XCTAssertNil(WishKit.user.customID)
        
        WishKit.updateUser(customID: customID)

        XCTAssertEqual(WishKit.user.customID, customID)
    }

    func testUpdateUserEmail() {
        let email = "hello@world.com"

        XCTAssertNil(WishKit.user.email)

        WishKit.updateUser(email: email)

        XCTAssertEqual(WishKit.user.email, email)
    }

    func testUpdateUserName() {
        let name = "Martin Lasek"

        XCTAssertNil(WishKit.user.name)

        WishKit.updateUser(name: name)

        XCTAssertEqual(WishKit.user.name, name)
    }

    func testUpdateUserPayment() {
        let payment: Payment = .monthly(23)

        XCTAssertNil(WishKit.user.payment)

        WishKit.updateUser(payment: payment)

        XCTAssertEqual(WishKit.user.payment?.amount, payment.amount)
    }
}
