//
//  MainTest.swift
//  
//
//  Created by Martin Lasek on 2/9/23.
//

import XCTest
import WishKitShared

@testable import WishKit

class MainTest: XCTestCase {

    override class func setUp() {
        // setup code
    }

    override func tearDown() {
        // tear down code
    }
}

final class WishModelFilterTests: XCTestCase {

    func testBucketPendingIncludesOnlyCurrentUserPending() {
        let currentUserUUID = UUID()

        let ownPending = makeWish(state: .pending, userUUID: currentUserUUID)
        let otherPending = makeWish(state: .pending, userUUID: UUID())

        XCTAssertEqual(WishModel.bucket(for: ownPending, currentUserUUID: currentUserUUID), .pending)
        XCTAssertEqual(WishModel.bucket(for: otherPending, currentUserUUID: currentUserUUID), .excluded)
    }

    func testBucketApprovedIncludesConfiguredStates() {
        let currentUserUUID = UUID()
        let approvedStates: [WishState] = [.approved, .inReview, .planned, .inProgress]

        approvedStates.forEach { state in
            let wish = makeWish(state: state)
            XCTAssertEqual(WishModel.bucket(for: wish, currentUserUUID: currentUserUUID), .approved)
        }
    }

    func testBucketCompletedIncludesCompletedAndImplemented() {
        let currentUserUUID = UUID()

        XCTAssertEqual(
            WishModel.bucket(for: makeWish(state: .completed), currentUserUUID: currentUserUUID),
            .completed
        )
        XCTAssertEqual(
            WishModel.bucket(for: makeWish(state: .implemented), currentUserUUID: currentUserUUID),
            .completed
        )
    }

    func testBucketExcludesRejected() {
        let currentUserUUID = UUID()
        let rejected = makeWish(state: .rejected)

        XCTAssertEqual(WishModel.bucket(for: rejected, currentUserUUID: currentUserUUID), .excluded)
    }

    func testMakeFilteredListsPartitionsAsExpected() {
        let currentUserUUID = UUID()

        let ownPending = makeWish(state: .pending, userUUID: currentUserUUID, votes: 5)
        let otherPending = makeWish(state: .pending, userUUID: UUID(), votes: 7)
        let approved = makeWish(state: .approved, votes: 6)
        let inReview = makeWish(state: .inReview, votes: 4)
        let planned = makeWish(state: .planned, votes: 3)
        let inProgress = makeWish(state: .inProgress, votes: 2)
        let completed = makeWish(state: .completed, votes: 9)
        let implemented = makeWish(state: .implemented, votes: 8)
        let rejected = makeWish(state: .rejected, votes: 1)

        let lists = WishModel.makeFilteredLists(
            from: [
                ownPending, otherPending, approved, inReview, planned,
                inProgress, completed, implemented, rejected
            ],
            currentUserUUID: currentUserUUID
        )

        XCTAssertEqual(lists.pending.map(\.id), [ownPending.id])
        XCTAssertEqual(
            Set(lists.approved.map(\.id)),
            Set([approved.id, inReview.id, planned.id, inProgress.id])
        )
        XCTAssertEqual(
            Set(lists.completed.map(\.id)),
            Set([completed.id, implemented.id])
        )
        XCTAssertFalse(lists.approved.contains(where: { $0.id == ownPending.id }))
        XCTAssertFalse(lists.approved.contains(where: { $0.id == completed.id }))
        XCTAssertFalse(lists.approved.contains(where: { $0.id == rejected.id }))
    }

    private func makeWish(
        state: WishState,
        userUUID: UUID = UUID(),
        votes: Int = 0
    ) -> WishResponse {
        let votingUsers = (0..<votes).map { _ in UserResponse(uuid: UUID()) }

        return WishResponse(
            id: UUID(),
            userUUID: userUUID,
            title: "title",
            description: "description",
            state: state,
            votingUsers: votingUsers,
            commentList: []
        )
    }
}
