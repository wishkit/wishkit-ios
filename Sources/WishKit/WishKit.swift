//
//  WishKit.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif

import SwiftUI
import WishKitShared

public struct WishKit {

    static var apiKey = "my-fancy-api-key"

    static var user = User()

    public static var theme = Theme()

    public static var config = Configuration()

    #if canImport(UIKit)
    /// (UIKit) The WishList viewcontroller.
    public static var viewController: UIViewController {
        return UIHostingController(rootView: WishlistViewIOS(wishModel: WishModel()))
    }
    #endif
    
    /// (SwiftUI) The WishList view.
    public static var view: some View {
        #if os(macOS)
            return WishlistContainer(wishModel: WishModel())
        #else
            return WishlistViewIOS(wishModel: WishModel()) // return WishListView()
        #endif
    }

    public static func configure(with apiKey: String) {
        WishKit.apiKey = apiKey
    }
}

// MARK: - Payment Model

class RoundUp: NSDecimalNumberBehaviors {
    func scale() -> Int16 {
        return 0
    }

    func exceptionDuringOperation(_ operation: Selector, error: NSDecimalNumber.CalculationError, leftOperand: NSDecimalNumber, rightOperand: NSDecimalNumber?) -> NSDecimalNumber? {
        return 0
    }

    func roundingMode() -> NSDecimalNumber.RoundingMode {
        .up
    }
}

public struct Payment {

    let amount: Int

    // MARK: - Weekly

    /// Accepts a price expressed in `Decimal` e.g: 2.99 or 11.49
    public static func weekly(_ amount: Decimal) -> Payment {
        let amount = NSDecimalNumber(decimal: amount * 100).intValue
        let amountPerMonth = amount * 4
        return Payment(amount: amountPerMonth)
    }

    /// Accepts a price expressed in `Double` e.g: 2.99 or 11.49
    public static func weekly(_ amount: Double) -> Payment {
        let amount = Int(amount * 100)
        let amountPerMonth = amount * 4
        return Payment(amount: amountPerMonth)
    }

    /// Accepts a price expressed in cents as `Int` e.g. instead of 2.99 (dollar) pass in 299 (cents).
    public static func weekly(_ amount: Int) -> Payment {
        let amountPerMonth = amount * 4
        return Payment(amount: amountPerMonth)
    }

    // MARK: - Monthly

    /// Accepts a price expressed in `Decimal` e.g: 6.99 or 19.49
    public static func monthly(_ amount: Decimal) -> Payment {
        let amount = NSDecimalNumber(decimal: amount * 100).intValue
        return Payment(amount: amount)
    }

    /// Accepts a price expressed in `Double` e.g: 6.99 or 19.49
    public static func monthly(_ amount: Double) -> Payment {
        let amount = Int(amount * 100)
        return Payment(amount: amount)
    }

    /// Accepts a price expressed in cents as `Int` e.g. instead of 19.49 (dollar) pass in 1949 (cents).
    public static func monthly(_ amount: Int) -> Payment {
        return Payment(amount: amount)
    }

    // MARK: - Yearly

    /// Accepts a price expressed in `Decimal` e.g: 6.99 or 19.49
    public static func yearly(_ amount: Decimal) -> Payment {
        let amountPerMonth = NSDecimalNumber(decimal: (amount * 100) / 12).rounding(accordingToBehavior: RoundUp()).intValue
        return Payment(amount: amountPerMonth)
    }

    /// Accepts a price expressed in `Double` e.g: 6.99 or 19.49
    public static func yearly(_ amount: Double) -> Payment {
        let amountPerMonth = Int((Double(amount * 100) / 12).rounded(.up))
        return Payment(amount: amountPerMonth)
    }

    /// Accepts a price expressed in `Int`.
    /// For example instead of 19.49 (dollar) pass in 1949 (cents).
    public static func yearly(_ amount: Int) -> Payment {
        let amountPerMonth = Int((Double(amount) / 12).rounded(.up))
        return Payment(amount: amountPerMonth)
    }
}

// MARK: - Update User Logic

extension WishKit {
    public static func updateUser(customID: String) {
        self.user.customID = customID
        sendUserToBackend()
    }

    public static func updateUser(email: String) {
        self.user.email = email
        sendUserToBackend()
    }

    public static func updateUser(name: String) {
        self.user.name = name
        sendUserToBackend()
    }

    public static func updateUser(payment: Payment) {
        self.user.payment = payment
        sendUserToBackend()
    }

    static func sendUserToBackend() {
        Task {
            let request = user.createRequest()
            let _ = await UserApi.updateUser(userRequest: request)
        }
    }
}
