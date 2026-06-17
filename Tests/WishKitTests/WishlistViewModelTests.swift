import Foundation
import XCTest
import WishKitShared

@testable import WishKit

@MainActor
final class WishlistViewModelTests: XCTestCase {

    private var originalConfig: Configuration!

    override func setUp() {
        super.setUp()
        originalConfig = WishKit.config
    }

    override func tearDown() {
        WishKit.config = originalConfig
        super.tearDown()
    }

    func testListReturnsAllWhenSegmentedControlIsHidden() {
        var config = WishKit.config
        config.buttons.segmentedControl.display = .hide
        WishKit.config = config

        let wishModel = WishModel()
        let viewModel = WishlistViewModel()

        let allWish = makeWish(state: .approved)
        wishModel.all = [allWish]
        wishModel.pendingList = []
        wishModel.approvedList = []
        wishModel.completedList = []

        let list = viewModel.list(for: wishModel)

        XCTAssertEqual(list.map(\.id), [allWish.id])
    }

    func testCountUsesBucketedStateWhenSegmentedControlIsVisible() {
        var config = WishKit.config
        config.buttons.segmentedControl.display = .show
        WishKit.config = config

        let wishModel = WishModel()
        let viewModel = WishlistViewModel()

        wishModel.approvedList = [makeWish(state: .approved), makeWish(state: .inReview)]
        let count = viewModel.count(for: .library(.planned), wishModel: wishModel)

        XCTAssertEqual(count, 2)
    }

    private func makeWish(
        state: WishState,
        userUUID: UUID = UUID()
    ) -> WishResponse {
        WishResponse(
            id: UUID(),
            userUUID: userUUID,
            title: "title",
            description: "description",
            state: state,
            votingUsers: [],
            commentList: []
        )
    }
}
