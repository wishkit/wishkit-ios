//
//  ChatViewModel.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/5/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation

struct ChatDisplayMessage: Identifiable, Equatable {

    enum Status: Equatable {
        case sent
        case pending
        case failed
    }

    let id: UUID
    let sender: ChatSender
    let body: String
    var status: Status
}

@MainActor
final class ChatViewModel: ObservableObject {

    static let maxMessageLength = 2000

    @Published var messages: [ChatDisplayMessage] = []
    @Published var hasLoaded = false
    @Published var isSending = false

    /// Server-controlled kill switch; the composer hides when false.
    @Published var chatAvailable = true

    private var seenServerMessageIds = Set<UUID>()

    /// Poll cursor. Only advanced by poll responses, never by a send response,
    /// so an admin message that lands during a send is not skipped.
    private var lastServerMessageId: UUID?

    private var pollTask: Task<Void, Never>?

    func startPolling() {
        stopPolling()

        pollTask = Task {
            await fetchNewMessages()

            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 5_000_000_000)

                guard !Task.isCancelled else {
                    break
                }

                await fetchNewMessages()
            }
        }
    }

    func stopPolling() {
        pollTask?.cancel()
        pollTask = nil
    }

    func send(text: String) {
        let trimmedText = String(text.trimmingCharacters(in: .whitespacesAndNewlines).prefix(Self.maxMessageLength))

        guard !trimmedText.isEmpty, !isSending else {
            return
        }

        let localMessage = ChatDisplayMessage(id: UUID(), sender: .user, body: trimmedText, status: .pending)
        messages.append(localMessage)

        Task {
            await deliver(localMessageId: localMessage.id, body: trimmedText)
        }
    }

    func retry(_ message: ChatDisplayMessage) {
        guard message.status == .failed else {
            return
        }

        if let messageIndex = messages.firstIndex(where: { existingMessage in existingMessage.id == message.id }) {
            messages[messageIndex].status = .pending
        }

        Task {
            await deliver(localMessageId: message.id, body: message.body)
        }
    }

    // MARK: - Private

    private func fetchNewMessages() async {
        let result = await ChatService.fetchMessages(after: lastServerMessageId)

        switch result {
        case .success(let response):
            chatAvailable = response.chatAvailable
            appendNewMessages(response.messages)
        case .failure:
            break // Silent; the next poll retries.
        }

        hasLoaded = true
    }

    private func appendNewMessages(_ serverMessages: [ChatMessage]) {
        for serverMessage in serverMessages where !seenServerMessageIds.contains(serverMessage.id) {
            seenServerMessageIds.insert(serverMessage.id)

            let displayMessage = ChatDisplayMessage(
                id: serverMessage.id,
                sender: serverMessage.sender,
                body: serverMessage.body,
                status: .sent
            )
            messages.append(displayMessage)
        }

        if let lastMessage = serverMessages.last {
            lastServerMessageId = lastMessage.id
        }
    }

    private func deliver(localMessageId: UUID, body: String) async {
        isSending = true
        defer { isSending = false }

        let result = await ChatService.sendMessage(body: body)

        switch result {
        case .success(let serverMessage):
            seenServerMessageIds.insert(serverMessage.id)

            if let messageIndex = messages.firstIndex(where: { existingMessage in existingMessage.id == localMessageId }) {
                messages[messageIndex] = ChatDisplayMessage(
                    id: serverMessage.id,
                    sender: .user,
                    body: serverMessage.body,
                    status: .sent
                )
            }
        case .failure:
            if let messageIndex = messages.firstIndex(where: { existingMessage in existingMessage.id == localMessageId }) {
                messages[messageIndex].status = .failed
            }
        }
    }
}
