import Foundation
import Combine
import WishKitShared

@MainActor
final class WishlistViewModel: ObservableObject {

    @Published
    var selectedWishState: LocalWishState = .library(.approved)

    var feedbackStateSelection: [LocalWishState] {
        [
            .library(.pending),
            .library(.approved),
            .library(.completed),
        ]
    }

    func list(for wishModel: WishModel) -> [WishResponse] {
        WishFiltering.list(
            from: lists(for: wishModel),
            selectedState: selectedWishState,
            segmentedControlDisplay: WishKit.config.buttons.segmentedControl.display
        )
    }

    func count(for state: LocalWishState, wishModel: WishModel) -> Int {
        WishFiltering.count(
            from: lists(for: wishModel),
            state: state,
            segmentedControlDisplay: WishKit.config.buttons.segmentedControl.display
        )
    }

    private func lists(for wishModel: WishModel) -> WishFiltering.Lists {
        WishFiltering.Lists(
            all: wishModel.all,
            pending: wishModel.pendingList,
            approved: wishModel.approvedList,
            completed: wishModel.completedList
        )
    }
}
