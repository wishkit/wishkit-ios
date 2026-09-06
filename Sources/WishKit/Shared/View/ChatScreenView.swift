//
//  ChatScreenView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/5/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import SwiftUI

/// The chat conversation: message history plus input bar. Polls every
/// 5 seconds while visible and in the foreground, nothing in the background.
struct ChatScreenView: View {

    @Environment(\.scenePhase)
    private var scenePhase

    @Environment(\.colorScheme)
    private var colorScheme

    @StateObject
    private var viewModel = ChatViewModel()

    @State
    private var messageText = ""

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.messages.enumerated()), id: \.element.id) { messageIndex, message in
                            ChatBubbleView(message: message, retryAction: { failedMessage in
                                viewModel.retry(failedMessage)
                            })
                            .padding(.top, topSpacing(for: messageIndex))
                            .id(message.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onChange(of: viewModel.messages) { updatedMessages in
                    guard let lastMessage = updatedMessages.last else {
                        return
                    }

                    withAnimation {
                        scrollProxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
                .overlay {
                    if viewModel.hasLoaded && viewModel.messages.isEmpty {
                        Text(WishKit.config.localization.chatEmptyState)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(30)
                    } else if !viewModel.hasLoaded {
                        ProgressView()
                    }
                }
            }

            if viewModel.chatAvailable {
                inputBar
            }
        }
        .background(backgroundColor.ignoresSafeArea())
        .onChange(of: messageText) { updatedText in
            if updatedText.count > ChatViewModel.maxMessageLength {
                messageText = String(updatedText.prefix(ChatViewModel.maxMessageLength))
            }
        }
        .onAppear {
            viewModel.startPolling()
        }
        .onDisappear {
            viewModel.stopPolling()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.startPolling()
            } else {
                viewModel.stopPolling()
            }
        }
    }

    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField(WishKit.config.localization.writeAMessage, text: $messageText, axis: .vertical)
                .lineLimit(1...4)
                .textFieldStyle(.plain)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(elementBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .onSubmit(sendMessage)

            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(WishKit.theme.primaryColor)
            }
            .buttonStyle(.plain)
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isSending)
            .accessibilityLabel(WishKit.config.localization.send)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private func sendMessage() {
        viewModel.send(text: messageText)
        messageText = ""
    }

    /// Same-sender bubbles stay tight; a sender change gets double the air.
    private func topSpacing(for messageIndex: Int) -> CGFloat {
        guard messageIndex > 0 else {
            return 0
        }

        let previousMessage = viewModel.messages[messageIndex - 1]
        let currentMessage = viewModel.messages[messageIndex]

        return previousMessage.sender == currentMessage.sender ? 6 : 12
    }

    private var backgroundColor: Color {
        WishKit.theme.tertiaryColor?.resolved(for: colorScheme) ?? PrivateTheme.systemBackground
    }

    private var elementBackgroundColor: Color {
        WishKit.theme.secondaryColor?.resolved(for: colorScheme) ?? PrivateTheme.elementBackground
    }
}

// MARK: - Bubble

struct ChatBubbleView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    let message: ChatDisplayMessage
    let retryAction: (ChatDisplayMessage) -> Void

    private var isOwnMessage: Bool {
        message.sender == .user
    }

    var body: some View {
        HStack {
            if isOwnMessage {
                Spacer(minLength: 50)
            }

            VStack(alignment: isOwnMessage ? .trailing : .leading, spacing: 3) {
                Text(message.body)
                    .foregroundColor(isOwnMessage ? .white : primaryTextColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(isOwnMessage ? WishKit.theme.primaryColor : elementBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                if message.status == .failed {
                    Text(WishKit.config.localization.failedToSendTapToRetry)
                        .font(.caption2)
                        .foregroundColor(.red)
                }
            }
            .opacity(message.status == .pending ? 0.5 : 1)
            .onTapGesture {
                if message.status == .failed {
                    retryAction(message)
                }
            }

            if !isOwnMessage {
                Spacer(minLength: 50)
            }
        }
        .frame(maxWidth: .infinity, alignment: isOwnMessage ? .trailing : .leading)
    }

    private var primaryTextColor: Color {
        WishKit.theme.textColor?.resolved(for: colorScheme) ?? .primary
    }

    private var elementBackgroundColor: Color {
        WishKit.theme.secondaryColor?.resolved(for: colorScheme) ?? PrivateTheme.elementBackground
    }
}
