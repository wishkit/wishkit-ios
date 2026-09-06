//
//  FeedbackChatButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/5/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(iOS) || os(macOS) || os(visionOS)
import SwiftUI

/// Floating circular chat button shown in the feedback board.
/// Opens the chat in a sheet; shows a dot when the admin replied.
struct FeedbackChatButton: View {

    @State
    private var isShowingChat = false

    @State
    private var hasUnread = false

    var body: some View {
        Button(action: openChat) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 21, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(WishKit.theme.primaryColor)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.25), radius: 5, y: 3)
                .overlay(alignment: .topTrailing) {
                    if hasUnread {
                        Circle()
                            .fill(.red)
                            .frame(width: 12, height: 12)
                            .padding(3)
                    }
                }
        }
        .buttonStyle(.plain)
        .padding(20)
        .accessibilityLabel(WishKit.config.localization.chat)
        .sheet(isPresented: $isShowingChat) {
            chatSheet
        }
        .task {
            await refreshUnreadStatus()
        }
    }

    private func openChat() {
        hasUnread = false
        isShowingChat = true
    }

    @ViewBuilder
    private var chatSheet: some View {
        #if os(macOS)
        VStack(spacing: 0) {
            HStack {
                Text(WishKit.config.localization.chat)
                    .font(.headline)
                Spacer()
                Button(WishKit.config.localization.done) {
                    isShowingChat = false
                }
            }
            .padding(12)

            Divider()

            ChatScreenView()
        }
        .frame(minWidth: 420, minHeight: 520)
        #else
        NavigationStack {
            ChatScreenView()
                .navigationTitle(WishKit.config.localization.chat)
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(WishKit.config.localization.done) {
                            isShowingChat = false
                        }
                    }
                }
        }
        #endif
    }

    private func refreshUnreadStatus() async {
        let result = await ChatService.fetchStatus()

        if case .success(let status) = result {
            hasUnread = status.chatAvailable && status.hasUnread
        }
    }
}
#endif
