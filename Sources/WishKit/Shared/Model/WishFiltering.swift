//
//  WishFiltering.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

struct WishFiltering {

    static func list(
        from lists: WishFilteringLists,
        selectedState: LocalWishState,
        segmentedControlDisplay: ConfigurationDisplay
    ) -> [WishResponse] {
        if segmentedControlDisplay == .hide {
            return lists.all
        }

        switch selectedState {
        case .all:
            return lists.all
        case .open:
            return (lists.pending + lists.approved)
                .sorted { $0.votingUsers.count > $1.votingUsers.count }
        case .closed:
            return lists.completed
        case .library(let state):
            switch state {
            case .pending:
                return lists.pending
            case .approved, .inReview, .planned, .inProgress:
                return lists.approved
            case .completed, .implemented:
                return lists.completed
            case .rejected:
                return []
            }
        }
    }

    static func count(
        from lists: WishFilteringLists,
        state: LocalWishState,
        segmentedControlDisplay: ConfigurationDisplay
    ) -> Int {
        list(
            from: lists,
            selectedState: state,
            segmentedControlDisplay: segmentedControlDisplay
        ).count
    }
}
