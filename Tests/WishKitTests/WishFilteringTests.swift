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

    func testListMergesPendingAndApprovedSortedByVotesForOpen() {
        let pending = makeWish(state: .pending, votes: 1)
        let approvedHigh = makeWish(state: .approved, votes: 5)
        let approvedLow = makeWish(state: .approved, votes: 0)
        let completed = makeWish(state: .completed, votes: 3)
        let lists = WishFilteringLists(
            all: [pending, approvedHigh, approvedLow, completed],
            pending: [pending],
            approved: [approvedHigh, approvedLow],
            completed: [completed]
        )

        let result = WishFiltering.list(
            from: lists,
            selectedState: .open,
            segmentedControlDisplay: .show
        )

        XCTAssertEqual(result.map(\.id), [approvedHigh.id, pending.id, approvedLow.id])
    }

    func testListReturnsCompletedForClosed() {
        let lists = makeLists()

        let result = WishFiltering.list(
            from: lists,
            selectedState: .closed,
            segmentedControlDisplay: .show
        )

        XCTAssertEqual(result.map(\.id), lists.completed.map(\.id))
    }

    private func makeLists() -> WishFilteringLists {
        let pending = makeWish(state: .pending)
        let approved = makeWish(state: .approved)
        let completed = makeWish(state: .completed)

        return WishFilteringLists(
            all: [pending, approved, completed],
            pending: [pending],
            approved: [approved],
            completed: [completed]
        )
    }

    private func makeWish(state: WishState, votes: Int = 0) -> WishResponse {
        WishResponse(
            id: UUID(),
            userUUID: UUID(),
            title: "title",
            description: "description",
            state: state,
            votingUsers: (0..<votes).map { _ in UserResponse(uuid: UUID()) },
            commentList: []
        )
    }
}
