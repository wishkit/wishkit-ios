import Foundation
import XCTest

@testable import WishKit

final class WishValidationTests: XCTestCase {

    func testNormalizeTrimsTitleAndDescription() {
        let result = WishValidation.normalize(
            title: String(repeating: "t", count: 80),
            description: String(repeating: "d", count: 700),
            email: "test@example.com"
        )

        XCTAssertEqual(result.title.count, WishValidation.titleLimit)
        XCTAssertEqual(result.description.count, WishValidation.descriptionLimit)
    }

    func testIsCreateButtonDisabledWhenEmptyTitleOrDescription() {
        XCTAssertTrue(WishValidation.isCreateButtonDisabled(title: "", description: "x"))
        XCTAssertTrue(WishValidation.isCreateButtonDisabled(title: "x", description: ""))
        XCTAssertFalse(WishValidation.isCreateButtonDisabled(title: "x", description: "y"))
    }

    func testValidateEmailRequiredMissing() {
        let result = WishValidation.validateEmail(
            email: "",
            fieldRequirement: .required
        )

        XCTAssertEqual(result, .requiredButMissing)
    }

    func testValidateEmailOptionalEmpty() {
        let result = WishValidation.validateEmail(
            email: "",
            fieldRequirement: .optional
        )

        XCTAssertEqual(result, .valid)
    }

    func testValidateEmailInvalidFormat() {
        let result = WishValidation.validateEmail(
            email: "abc",
            fieldRequirement: .optional
        )

        XCTAssertEqual(result, .invalidFormat)
    }

    func testValidateEmailValidFormat() {
        let result = WishValidation.validateEmail(
            email: "person@example.com",
            fieldRequirement: .optional
        )

        XCTAssertEqual(result, .valid)
    }
}
