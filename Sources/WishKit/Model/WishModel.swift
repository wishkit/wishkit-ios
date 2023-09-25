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

final class WishModel: ObservableObject {

    @Published
    var approvedWishlist: [WishResponse] = []

    @Published
    var implementedWishlist: [WishResponse] = []

    @Published
    var shouldShowWatermark: Bool = false

    func fetchList(completion: (() -> ())? = nil) {
        WishApi.fetchWishList { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.updateApprovedWishlist(with: response.list)
                    self.updateImplementedWishlist(with: response.list)
                    self.shouldShowWatermark = response.shouldShowWatermark
                }
            case .failure(let error):
                printError(self, error.reason.description)
            }

            completion?()
        }
    }

    @Sendable
    func fetchList() {
        fetchList(completion: nil)
    }

    private func updateApprovedWishlist(with list: [WishResponse]) {
        let userUUID = UUIDManager.getUUID()

        var filteredList = list.filter { wish in
            let ownPendingWish = (wish.state == .pending && wish.userUUID == userUUID)
            let approvedWish = wish.state == .approved

            return ownPendingWish || approvedWish
        }

        filteredList.sort { $0.votingUsers.count > $1.votingUsers.count }

        self.approvedWishlist = filteredList
    }

    private func updateImplementedWishlist(with list: [WishResponse]) {
        var filteredList = list.filter { wish in wish.state == .implemented }
        filteredList.sort { $0.votingUsers.count > $1.votingUsers.count }
        self.implementedWishlist = filteredList
    }
}
