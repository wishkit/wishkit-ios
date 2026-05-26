import WishKitShared

struct WishModelAccumulator {
    var pending: [WishResponse] = []
    var approved: [WishResponse] = []
    var completed: [WishResponse] = []
    var inReview: [WishResponse] = []
    var planned: [WishResponse] = []
    var inProgress: [WishResponse] = []
}
