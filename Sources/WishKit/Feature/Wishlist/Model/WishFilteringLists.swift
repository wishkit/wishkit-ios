import WishKitShared

struct WishFilteringLists {
    let all: [WishResponse]
    let pending: [WishResponse]
    let approved: [WishResponse]
    let completed: [WishResponse]
}
