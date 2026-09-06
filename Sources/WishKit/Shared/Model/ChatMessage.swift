//
//  ChatMessage.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/5/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation

enum ChatSender: String, Codable {
    case user
    case admin

    /// Unknown future sender kinds must never break decoding for shipped
    /// versions; anything that isn't the user renders as the other side.
    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        self = ChatSender(rawValue: rawValue) ?? .admin
    }
}

struct ChatMessage: Codable, Identifiable, Equatable {
    let id: UUID
    let sender: ChatSender
    let body: String
    let createdAt: String
}

struct ChatMessagesResponse: Codable {
    let chatAvailable: Bool
    let messages: [ChatMessage]
}

struct ChatStatusResponse: Codable {
    let chatAvailable: Bool
    let hasUnread: Bool
}

struct ChatSendMessageRequest: Codable {
    let body: String
}
