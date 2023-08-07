//
//  User.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import WishKitShared

final class User {
    var customID: String?
    var email: String?
    var name: String?
    var payment: Payment?

    init(customID: String? = nil, email: String? = nil, name: String? = nil, payment: Payment? = nil) {
        self.customID = customID
        self.email = email
        self.name = name
        self.payment = payment
    }

    func createRequest() -> UserRequest {
        let userRequest = UserRequest(
            customID: customID,
            email: email,
            name: name,
            paymentPerMonth: payment?.amount
        )

        return userRequest
    }
}
