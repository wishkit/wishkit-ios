//
//  FeedbackLanguageTests.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 7/28/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation
import XCTest

@testable import WishKit

final class FeedbackLanguageTests: XCTestCase {

    // The test bundle runs in English, so German feedback differs.
    func testGermanTextDiffersFromEnglishAppLanguage() {
        let text = "Es wäre großartig, wenn man den Dunkelmodus aktivieren könnte."

        XCTAssertTrue(FeedbackLanguage.differsFromAppLanguage(text))
    }

    func testEnglishTextMatchesEnglishAppLanguage() {
        let text = "It would be great to have dark mode support in the app."

        XCTAssertFalse(FeedbackLanguage.differsFromAppLanguage(text))
    }

    /// Short texts are unreliable to detect, so they never count as different.
    func testShortTextNeverCountsAsDifferent() {
        XCTAssertFalse(FeedbackLanguage.differsFromAppLanguage("Dark Mode"))
        XCTAssertNil(FeedbackLanguage.dominantLanguage(of: "Modus"))
    }

    func testRegionalVariantsMatch() {
        let german = Locale.Language(identifier: "de")
        let austrianGerman = Locale.Language(identifier: "de-AT")

        XCTAssertTrue(FeedbackLanguage.matches(german, austrianGerman))
    }

    /// Scripts matter: Simplified and Traditional Chinese are different targets.
    func testChineseScriptsDoNotMatch() {
        let simplified = Locale.Language(identifier: "zh-Hans")
        let traditional = Locale.Language(identifier: "zh-Hant")

        XCTAssertFalse(FeedbackLanguage.matches(simplified, traditional))
        XCTAssertTrue(FeedbackLanguage.matches(simplified, Locale.Language(identifier: "zh-Hans")))
    }
}
