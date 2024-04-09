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
import Combine

public struct WishKit {
    
    private static var subscribers: Set<AnyCancellable> = []

    static var apiKey = "my-fancy-api-key"

    static var user = User()

    public static var theme = Theme()

    public static var config = Configuration()

    #if canImport(UIKit) && !os(visionOS)
    /// (UIKit) The WishList viewcontroller.
    public static var viewController: UIViewController {
        UIHostingController(rootView: WishlistViewIOS(wishModel: WishModel()))
    }
    #endif
    
    /// (SwiftUI) The WishList view.
    public static var view: some View {
        #if os(macOS) || os(visionOS)
            return WishlistContainer(wishModel: WishModel())
        #else
            return WishlistViewIOS(wishModel: WishModel())
        #endif
    }

    #if canImport(UIKit) && !os(visionOS)
    /// (UIKit) The WishList viewcontroller.
    public static var privateFeedbackViewController: UIViewController {
        UIHostingController(rootView: PrivateFeedbackView())
    }
    #endif

    /// (SwiftUI) The WishList view.
    public static var privateFeedbackView: some View {
        #if os(macOS) || os(visionOS)
            return PrivateFeedbackView()
        #else
            return PrivateFeedbackView()
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

    // MARK: - Monthly

    /// Accepts a price expressed in `Decimal` e.g: 6.99 or 19.49
    public static func monthly(_ amount: Decimal) -> Payment {
        let amount = NSDecimalNumber(decimal: amount * 100).intValue
        return Payment(amount: amount)
    }

    // MARK: - Yearly

    /// Accepts a price expressed in `Decimal` e.g: 6.99 or 19.49
    public static func yearly(_ amount: Decimal) -> Payment {
        let amountPerMonth = NSDecimalNumber(decimal: (amount * 100) / 12).rounding(accordingToBehavior: RoundUp()).intValue
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
