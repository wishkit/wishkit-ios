import Foundation
import WishKitShared

enum LocalWishState: Hashable, Identifiable {

    case all

    case library(WishState)

    var id: String { description }

    var description: String {
        switch self {
        case .all:
            return "All"
        case .library(let wishState):
            return wishState.description
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}
