import Foundation
import XCTest
import WishKitShared

@testable import WishKit

@MainActor
final class CreateWishViewModelTests: XCTestCase {

    private var originalConfig: Configuration!

    override func setUp() {
        super.setUp()
        originalConfig = WishKit.config
    }

    override func tearDown() {
        WishKit.config = originalConfig
        super.tearDown()
    }

    func testHandleTitleAndDescriptionChangeTrimsAndEnablesButton() {
        let viewModel = CreateWishViewModel()
        viewModel.titleText = String(repeating: "a", count: 70)
        viewModel.descriptionText = String(repeating: "b", count: 700)

        viewModel.handleTitleAndDescriptionChange()

        XCTAssertEqual(viewModel.titleText.count, 50)
        XCTAssertEqual(viewModel.descriptionText.count, 500)
        XCTAssertFalse(viewModel.isButtonDisabled)
    }

    func testSubmitReturnsEmailRequiredWhenRequiredAndMissing() async {
        var config = WishKit.config
        config.emailField = .required
        WishKit.config = config

        let viewModel = CreateWishViewModel()
        viewModel.titleText = "Title"
        viewModel.descriptionText = "Description"

        let result = await viewModel.submit()

        XCTAssertEqual(result, .emailRequired)
        XCTAssertFalse(viewModel.isButtonLoading)
    }

    func testSubmitReturnsEmailFormatWrongWhenInvalidEmailProvided() async {
        var config = WishKit.config
        config.emailField = .optional
        WishKit.config = config

        let viewModel = CreateWishViewModel()
        viewModel.titleText = "Title"
        viewModel.descriptionText = "Description"
        viewModel.emailText = "abc"

        let result = await viewModel.submit()

        XCTAssertEqual(result, .emailFormatWrong)
        XCTAssertFalse(viewModel.isButtonLoading)
    }

    func testSubmitTogglesLoadingAroundApiCall() async {
        var observedLoadingDuringRequest = false
        var viewModel: CreateWishViewModel!

        viewModel = CreateWishViewModel(createWishAction: { _ in
            observedLoadingDuringRequest = viewModel.isButtonLoading
            return .failure(ApiError(reason: .requestResultedInError))
        })
        viewModel.titleText = "Title"
        viewModel.descriptionText = "Description"

        let result = await viewModel.submit()

        guard case .createReturnedError(let message) = result else {
            XCTFail("Expected createReturnedError outcome.")
            return
        }
        XCTAssertFalse(message.isEmpty)
        XCTAssertTrue(observedLoadingDuringRequest)
        XCTAssertFalse(viewModel.isButtonLoading)
    }
}
