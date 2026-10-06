//
//  PaymentTests.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 10/6/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import XCTest

@testable import WishKit

/// Every payment is converted to cents per month before it is sent.
final class PaymentTests: XCTestCase {

    func testMonthlyIsTakenAsIs() {
        XCTAssertEqual(Payment.monthly(7.99).amount, 799)
    }

    func testWeeklyUsesFiftyTwoWeeksPerYear() {
        // 2.99 x 52 / 12 = 12.9566..., rounded up to the next cent.
        XCTAssertEqual(Payment.weekly(2.99).amount, 1296)
        // 3.00 x 52 / 12 = 13.00 exactly.
        XCTAssertEqual(Payment.weekly(3).amount, 1300)
    }

    func testYearlyIsSpreadOverTwelveMonths() {
        // 59.99 / 12 = 4.9991..., rounded up to the next cent.
        XCTAssertEqual(Payment.yearly(59.99).amount, 500)
    }
}
