//
//  ChatService.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/5/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

struct ChatService: RequestCreatable {

    private static let baseUrl = "\(ProjectSettings.apiUrl)/chat"

    static func fetchStatus() async -> ApiResult<ChatStatusResponse, ApiError> {
        guard let url = URL(string: "\(baseUrl)/status") else {
            return .failure(ApiError(reason: .couldNotCreateRequest))
        }

        return await ApiClient.send(request: createAuthedGETRequest(to: url))
    }

    /// Without `after` the full thread; with `after` only newer messages.
    static func fetchMessages(after messageId: UUID?) async -> ApiResult<ChatMessagesResponse, ApiError> {
        var urlString = "\(baseUrl)/messages"

        if let messageId {
            urlString += "?after=\(messageId.uuidString)"
        }

        guard let url = URL(string: urlString) else {
            return .failure(ApiError(reason: .couldNotCreateRequest))
        }

        return await ApiClient.send(request: createAuthedGETRequest(to: url))
    }

    static func sendMessage(body: String) async -> ApiResult<ChatMessage, ApiError> {
        guard let url = URL(string: "\(baseUrl)/message") else {
            return .failure(ApiError(reason: .couldNotCreateRequest))
        }

        return await ApiClient.send(request: createAuthedPOSTRequest(to: url, with: ChatSendMessageRequest(body: body)))
    }
}
