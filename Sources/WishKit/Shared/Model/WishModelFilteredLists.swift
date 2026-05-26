import WishKitShared

struct WishModelFilteredLists {
    let sortedList: [WishResponse]
    let pending: [WishResponse]
    let approved: [WishResponse]
    let completed: [WishResponse]
    let inReview: [WishResponse]
    let planned: [WishResponse]
    let inProgress: [WishResponse]
}
