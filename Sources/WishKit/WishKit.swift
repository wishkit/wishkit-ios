//
//  WishKit.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import WishKitShared
import Combine
import Foundation

public struct WishKit {

    private static let threadLock = NSLock()

    private static var subscribers: Set<AnyCancellable> = []
    
    private static var sendUserTask: Task<Void, Never>?

    static var apiKey = "my-fancy-api-key"

    static var user = User()

    static var _theme = Theme()

    static var _config = Configuration()

    public static var theme: Theme {
        get {
            threadLock.withLock { _theme }
        } set {
            threadLock.withLock { _theme = newValue }
        }
    }

    public static var config: Configuration {
        get {
            threadLock.withLock { _config }
        } set {
            threadLock.withLock { _config = newValue }
        }
    }

    public static func configure(with apiKey: String) {
        WishKit.apiKey = apiKey
    }
}

// MARK: - Update User Logic

extension WishKit {
    public static func updateUser(customID: String) {
        user.customID = customID
        sendUserToBackend()
    }

    public static func updateUser(email: String) {
        user.email = email
        sendUserToBackend()
    }

    public static func updateUser(name: String) {
        user.name = name
        sendUserToBackend()
    }

    public static func updateUser(payment: Payment) {
        user.payment = payment
        sendUserToBackend()
    }

    static func sendUserToBackend() {
        threadLock.withLock {
            sendUserTask?.cancel()
            let request = user.createRequest()
            sendUserTask = Task {
                guard !Task.isCancelled else { return }
                let _ = await UserService.updateUser(userRequest: request)
            }
        }
    }
}
