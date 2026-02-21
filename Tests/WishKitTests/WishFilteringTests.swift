import Foundation
import XCTest
import WishKitShared

@testable import WishKit

final class WishFilteringTests: XCTestCase {

    func testListReturnsAllWhenSegmentedControlHidden() {
        let lists = makeLists()

        let result = WishFiltering.list(
            from: lists,
            selectedState: .library(.pending),
            segmentedControlDisplay: .hide
        )

        XCTAssertEqual(result.map(\.id), lists.all.map(\.id))
    }

    func testListMapsApprovedBucketForGroupedStates() {
        let lists = makeLists()

        let approved = WishFiltering.list(
            from: lists,
            selectedState: .library(.approved),
            segmentedControlDisplay: .show
        )
        let inReview = WishFiltering.list(
            from: lists,
            selectedState: .library(.inReview),
            segmentedControlDisplay: .show
        )

        XCTAssertEqual(approved.map(\.id), lists.approved.map(\.id))
        XCTAssertEqual(inReview.map(\.id), lists.approved.map(\.id))
    }

    func testListReturnsEmptyForRejectedBucketWhenVisible() {
        let lists = makeLists()

        let result = WishFiltering.list(
            from: lists,
            selectedState: .library(.rejected),
            segmentedControlDisplay: .show
        )

        XCTAssertTrue(result.isEmpty)
    }

    func testCountDelegatesToListBehavior() {
        let lists = makeLists()

        let count = WishFiltering.count(
            from: lists,
            state: .library(.completed),
            segmentedControlDisplay: .show
        )

        XCTAssertEqual(count, lists.completed.count)
    }

    private func makeLists() -> WishFiltering.Lists {
        let pending = makeWish(state: .pending)
        let approved = makeWish(state: .approved)
        let completed = makeWish(state: .completed)

        return WishFiltering.Lists(
            all: [pending, approved, completed],
            pending: [pending],
            approved: [approved],
            completed: [completed]
        )
    }

    private func makeWish(state: WishState) -> WishResponse {
        WishResponse(
            id: UUID(),
            userUUID: UUID(),
            title: "title",
            description: "description",
            state: state,
            votingUsers: [],
            commentList: []
        )
    }
}
