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

@MainActor
final class WishModel: ObservableObject {

    @Published
    var wishlist: [WishResponse] = []

    func fetchList() {
        WishApi.fetchWishList { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.wishlist = response.list
                }
            case .failure(let error):
                printError(self, error.description)
            }
        }
    }
}
