import Foundation
import XCTest
import WishKitShared

@testable import WishKit

@MainActor
final class DetailWishViewModelTests: XCTestCase {

    func testSubmitCommentSkipsWhitespaceOnlyInput() async {
        var callCount = 0
        let viewModel = DetailWishViewModel(commentList: [], createCommentAction: { _ in
            callCount += 1
            return .failure(ApiError(reason: .requestResultedInError))
        })

        viewModel.newCommentValue = "   \n  "
        await viewModel.submitComment(for: UUID())

        XCTAssertEqual(callCount, 0)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testSubmitCommentTogglesLoadingAroundRequest() async {
        var observedLoadingDuringRequest = false
        var capturedDescription: String?
        var viewModel: DetailWishViewModel!

        viewModel = DetailWishViewModel(commentList: [], createCommentAction: { request in
            observedLoadingDuringRequest = viewModel.isLoading
            capturedDescription = request.description
            return .failure(ApiError(reason: .requestResultedInError))
        })

        viewModel.newCommentValue = "  hello world  "
        await viewModel.submitComment(for: UUID())

        XCTAssertTrue(observedLoadingDuringRequest)
        XCTAssertEqual(capturedDescription, "hello world")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.newCommentValue, "  hello world  ")
    }
}
