//
//  WishModel.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/11/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Combine
import WishKitShared
import Foundation
import SwiftUI

final class WishModel: ObservableObject {

    @Published
    var all: [WishResponse] = []

    @Published
    var pendingList: [WishResponse] = []

    @Published
    var approvedList: [WishResponse] = []

    @Published
    var inReviewList: [WishResponse] = []

    @Published
    var plannedList: [WishResponse] = []

    @Published
    var inProgressList: [WishResponse] = []

    @Published
    var completedList: [WishResponse] = []

    /// This list includes pending feedback from all users.
    @Published
    var fullList: [WishResponse] = []

    @Published
    var shouldShowWatermark: Bool = false

    @Published
    var isLoading: Bool = false

    // Used to differentiate empty list from fetch vs. from initial instance creation.
    @Published
    var hasFetched: Bool = false

    @MainActor
    func fetchList(completion: (() -> ())? = nil) {
        Task { @MainActor in
            await fetchListAsync()
            completion?()
        }
    }

    @MainActor
    func fetchList() {
        fetchList(completion: nil)
    }

    @MainActor
    func fetchListAsync() async {
        isLoading = true

        let result = await WishService.fetchWishList()
        switch result {
        case .success(let response):
            updateAllLists(with: response.list)
            shouldShowWatermark = response.shouldShowWatermark
            fullList = response.list
        case .failure(let error):
            printError(self, error.reason.description)
        }

        isLoading = false
        hasFetched = true
    }

    private func updateAllLists(with list: [WishResponse]) {
        let lists = Self.makeFilteredLists(
            from: list,
            currentUserUUID: UUIDManager.getUUID()
        )

        pendingList = lists.pending
        approvedList = lists.approved
        completedList = lists.completed

        // Keep old lists populated so existing public behavior is preserved.
        inReviewList = lists.inReview
        plannedList = lists.planned
        inProgressList = lists.inProgress

        all = (lists.pending + lists.approved + lists.completed)
            .sorted { $0.votingUsers.count > $1.votingUsers.count }

    }

    static func bucket(for wish: WishResponse, currentUserUUID: UUID) -> WishModelFilterBucket {
        switch wish.state {
        case .pending:
            // Pending should only surface your own requests.
            // Excluded here means pending wishes created by other users.
            return wish.userUUID == currentUserUUID ? .pending : .excluded
        case .completed, .implemented:
            return .completed
        case .rejected:
            // Rejected is intentionally hidden from all 3 tabs.
            return .excluded
        case .approved, .inReview, .planned, .inProgress:
            // "Approved" view intentionally groups all active non-pending work.
            return .approved
        @unknown default:
            // Safety fallback for future states not yet handled by this SDK version.
            return .excluded
        }
    }

    static func makeFilteredLists(
        from list: [WishResponse],
        currentUserUUID: UUID
    ) -> WishModelFilteredLists {
        let sortedList = list.sorted { $0.votingUsers.count > $1.votingUsers.count }

        let result = sortedList.reduce(into: WishModelAccumulator()) { result, wish in
            switch bucket(for: wish, currentUserUUID: currentUserUUID) {
            case .pending:
                result.pending.append(wish)
            case .completed:
                result.completed.append(wish)
            case .approved:
                result.approved.append(wish)
            case .excluded:
                break
            }

            switch wish.state {
            case .approved, .inReview:
                result.inReview.append(wish)
            case .planned:
                result.planned.append(wish)
            case .inProgress:
                result.inProgress.append(wish)
            default:
                break
            }
        }

        return WishModelFilteredLists(
            sortedList: sortedList,
            pending: result.pending,
            approved: result.approved,
            completed: result.completed,
            inReview: result.inReview,
            planned: result.planned,
            inProgress: result.inProgress
        )
    }
}
