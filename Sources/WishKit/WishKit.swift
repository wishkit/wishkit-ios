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
    
    private static let threadLock = NSLock()
    
    private static var subscribers: Set<AnyCancellable> = []

    static var apiKey = "my-fancy-api-key"

    static var user = User()

    static var _theme = Theme()
    
    static var _config = Configuration()

    public static var theme: Theme {
        get {
            return threadLock.withLock { _theme }
        } set {
            threadLock.withLock { _theme = newValue }
        }
    }

    public static var config: Configuration {
        get {
            return threadLock.withLock { _config }
        } set {
            threadLock.withLock { _config = newValue }
        }
    }

    #if canImport(UIKit) && !os(visionOS)
    /// (UIKit) The WishList viewcontroller.
    public static var viewController: UIViewController {
        UIHostingController(rootView: WishlistViewIOS(wishModel: WishModel()))
    }
    #endif
    
    /// (SwiftUI) The WishList view.
    @available(*, deprecated, message: "Use `WishKit.FeedbackListView()` instead.")
    public static var view: some View {
        #if os(macOS) || os(visionOS)
            return WishlistContainer(wishModel: WishModel())
        #else
            return WishlistViewIOS(wishModel: WishModel())
        #endif
    }

    public static func configure(with apiKey: String) {
        WishKit.apiKey = apiKey
    }

    /// FeedbackView that renders the list of feedback.
    public struct FeedbackListView: View {
        
        public init () { }
        
        public var body: some View {
        #if os(macOS) || os(visionOS)
            WishlistContainer(wishModel: WishModel())
        #else
            WishlistViewIOS(wishModel: WishModel())
        #endif
        }
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
