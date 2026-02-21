import Foundation
import WishKitShared

struct WishFiltering {

    struct Lists {
        let all: [WishResponse]
        let pending: [WishResponse]
        let approved: [WishResponse]
        let completed: [WishResponse]
    }

    static func list(
        from lists: Lists,
        selectedState: LocalWishState,
        segmentedControlDisplay: Configuration.Display
    ) -> [WishResponse] {
        if segmentedControlDisplay == .hide {
            return lists.all
        }

        switch selectedState {
        case .all:
            return lists.all
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
        from lists: Lists,
        state: LocalWishState,
        segmentedControlDisplay: Configuration.Display
    ) -> Int {
        list(
            from: lists,
            selectedState: state,
            segmentedControlDisplay: segmentedControlDisplay
        ).count
    }
}
