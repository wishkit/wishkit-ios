//
//  WishKit+ChatView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/5/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import SwiftUI

extension WishKit {
    /// Chat between your app's users and you. Place it anywhere:
    /// `WishKit.ChatView()`. The feedback board also shows a floating chat
    /// button by default (see `WishKit.config.showChatButtonInFeedbackView`).
    public struct ChatView: View {

        public init() {}

        public var body: some View {
            ChatScreenView()
        }
    }

    /// Whether chat is available and the user has unread replies.
    /// Lets host apps badge their own chat entry point; call it whenever
    /// fits (for example on foreground), the SDK does not poll it itself.
    public static func chatStatus() async -> (available: Bool, hasUnread: Bool) {
        let result = await ChatService.fetchStatus()

        switch result {
        case .success(let status):
            return (status.chatAvailable, status.hasUnread)
        case .failure:
            return (false, false)
        }
    }
}
