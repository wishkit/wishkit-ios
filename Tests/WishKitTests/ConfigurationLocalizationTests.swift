//
//  ConfigurationLocalizationTests.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 7/27/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import XCTest

@testable import WishKit

final class ConfigurationLocalizationTests: XCTestCase {

    /// NSLocalizedString returns the key itself when the table is missing,
    /// so values equaling their keys means the bundled translations didn't load.
    func testDefaultValuesResolveFromBundledTranslations() {
        let localization = ConfigurationLocalization.default()

        XCTAssertNotEqual(localization.requested, "requested")
        XCTAssertNotEqual(localization.pending, "pending")
        XCTAssertNotEqual(localization.open, "open")
        XCTAssertNotEqual(localization.closed, "closed")
        XCTAssertNotEqual(localization.somethingWentWrong, "somethingWentWrong")
        XCTAssertNotEqual(localization.activateToSwitchFilter, "activateToSwitchFilter")
    }

    func testConsumerOverrideWinsOverBundledDefault() {
        let localization = ConfigurationLocalization(open: "Offen")

        XCTAssertEqual(localization.open, "Offen")
        XCTAssertNotEqual(localization.closed, "closed")
    }
}
