//
//  WishView+macOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/10/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(macOS)
import SwiftUI
import WishKitShared

struct WishView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @State
    private var voteCount: Int

    @State
    private var isVotedByCurrentUser: Bool

    @State
    private var isVoting = false

    @State
    private var voteCountScale: CGFloat = 1

    @State
    private var voteButtonOpacity: CGFloat = 1

    @State
    private var voteTask: Task<Void, Never>?

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    /// Reports vote alerts to the parent view, which presents them outside the `List` —
    /// a SwiftUI alert attached inside a macOS `List` row never presents.
    private let onVoteAlert: (AlertReason) -> Void

    private let viewKind: WishViewKind

    private var descriptionLineLimit: Int? {
        if viewKind == .detail {
            return nil
        }

        return WishKit.config.expandDescriptionInList ? nil : 1
    }
    
    private var buttonCornerRadius: CGFloat {
        if #available(iOS 26.0, visionOS 26.0, macOS 26.0, *) {
            return 12
        } else {
            return 8
        }
    }

    init(
        wishResponse: WishResponse,
        viewKind: WishViewKind,
        voteActionCompletion: @escaping (() -> Void),
        onVoteAlert: @escaping (AlertReason) -> Void
    ) {
        let currentUserUUID = UUIDManager.getUUID()
        let hasVotedByCurrentUser = wishResponse.votingUsers.contains { user in
            user.uuid == currentUserUUID
        }

        self.wishResponse = wishResponse
        self.viewKind = viewKind
        self.voteActionCompletion = voteActionCompletion
        self.onVoteAlert = onVoteAlert
        self._voteCount = .init(initialValue: wishResponse.votingUsers.count)
        self._isVotedByCurrentUser = .init(initialValue: hasVotedByCurrentUser)
    }

    var body: some View {
        Group {
            if viewKind == .detail {
                content
                    .padding(10)
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
            } else {
                content
                    .padding(.vertical, 4)
            }
        }
    }

    private var content: some View {
        HStack(spacing: 0) {
            Button(action: voteAction) {
                VStack(spacing: 5) {
                    upvoteIconImage
                        .imageScale(.medium)
                    WishVoteCountTextView(
                        voteCount: voteCount,
                        voteCountScale: voteCountScale,
                        font: .callout.weight(.semibold)
                    )
                }
                .frame(width: 50, height: 50)
                .opacity(voteButtonOpacity)
            }
            .buttonStyle(.borderless)
            .tint(isVotedByCurrentUser ? .white : voteTint)
            .background(isVotedByCurrentUser ? WishKit.theme.primaryColor : voteTint.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: buttonCornerRadius, style: .continuous))
            .padding(.trailing, 14)
            .disabled(isVoting)
            .onChange(of: isVoting) { newValue in
                if newValue {
                    startVoteButtonHeartbeat()
                } else {
                    stopVoteButtonHeartbeat()
                }
            }
            .onDisappear {
                voteTask?.cancel()
                voteTask = nil
                stopVoteButtonHeartbeat()
            }
            .onChange(of: wishResponse.votingUsers.count) { newValue in
                guard isVoting == false else {
                    return
                }

                voteCount = newValue
            }
            .onChange(of: serverHasVotedByCurrentUser) { newValue in
                guard isVoting == false else {
                    return
                }

                isVotedByCurrentUser = newValue
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(wishResponse.title)
                        .foregroundColor(textColor)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(viewKind == .list ? 1 : nil)

                    Spacer()

                    // Pending always shows its badge — it's how users spot their own unapproved feedback in "Open".
                    if viewKind == .list && (WishKit.config.statusBadge == .show || wishResponse.state == .pending) {
                        Text(wishResponse.state.description.uppercased())
                            .opacity(0.8)
                            .font(.caption2)
                            .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                            .foregroundColor(.primary)
                            .background(badgeColor(for: wishResponse.state).opacity(1 / 3))
                            .cornerRadius(6)
                    }
                }

                Text(wishResponse.description)
                    .foregroundColor(textColor)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .lineLimit(descriptionLineLimit)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    func badgeColor(for wishState: WishState) -> Color {
        color(from: badgeScheme(for: wishState))
    }

    private func voteAction() {
        guard isVoting == false else {
            return
        }

        if wishResponse.state == .implemented || wishResponse.state == .completed {
            onVoteAlert(.alreadyCompleted)
            return
        }

        if isVotedByCurrentUser && WishKit.config.allowUndoVote == false {
            onVoteAlert(.alreadyVoted)
            return
        }

        let voteDelta = isVotedByCurrentUser ? -1 : 1
        isVoting = true

        voteTask?.cancel()
        voteTask = Task { @MainActor in
            let requestStartedAt = Date()
            let request = VoteWishRequest(wishId: wishResponse.id)
            let result = await WishService.voteWish(voteRequest: request)
            guard !Task.isCancelled else {
                return
            }

            let minimumPulseDuration: TimeInterval = 0.45
            let elapsed = Date().timeIntervalSince(requestStartedAt)
            if elapsed < minimumPulseDuration {
                let remaining = minimumPulseDuration - elapsed
                try? await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000))
            }

            isVoting = false
            voteTask = nil

            switch result {
            case .success:
                applyVoteSuccessAnimations(voteDelta: voteDelta)
                voteActionCompletion()
            case .failure(let error):
                onVoteAlert(.voteReturnedError(error.localizedDescription))
            }
        }
    }

    private func applyVoteSuccessAnimations(voteDelta: Int) {
        guard voteDelta != 0 else {
            return
        }

        withAnimation(.easeOut(duration: 0.2)) {
            isVotedByCurrentUser = voteDelta > 0
            voteCount += voteDelta
            voteCountScale = 1.15
        }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.7).delay(0.08)) {
            voteCountScale = 1
        }
    }

    @MainActor
    private func startVoteButtonHeartbeat() {
        voteButtonOpacity = 1
        withAnimation(.easeInOut(duration: 0.22).repeatForever(autoreverses: true)) {
            voteButtonOpacity = 0.62
        }
    }

    @MainActor
    private func stopVoteButtonHeartbeat() {
        withAnimation(.easeOut(duration: 0.2)) {
            voteButtonOpacity = 1
        }
    }

    private var serverHasVotedByCurrentUser: Bool {
        let currentUserUUID = UUIDManager.getUUID()
        return wishResponse.votingUsers.contains { user in
            user.uuid == currentUserUUID
        }
    }

    /// Builds the vote alert. Presented by the parent views (list / detail), never
    /// inside the row itself — a SwiftUI alert attached inside a macOS `List` row never presents.
    static func makeVoteAlert(for reason: AlertReason) -> Alert {
        let message: String
        switch reason {
        case .alreadyVoted:
            message = WishKit.config.localization.youCanOnlyVoteOnce
        case .alreadyCompleted:
            message = WishKit.config.localization.youCanNotVoteForACompletedWish
        case .voteReturnedError(let error):
            message = "Something went wrong during your vote. Try again later.\n\n\(error)"
        default:
            message = "Something went wrong during your vote. Try again later."
        }

        return Alert(title: Text(message))
    }

    private func badgeScheme(for wishState: WishState) -> ThemeScheme {
        switch wishState {
        case .approved:
            return WishKit.theme.badgeColor.inReview
        case .implemented:
            return WishKit.theme.badgeColor.completed
        case .pending:
            return WishKit.theme.badgeColor.pending
        case .inReview:
            return WishKit.theme.badgeColor.inReview
        case .planned:
            return WishKit.theme.badgeColor.planned
        case .inProgress:
            return WishKit.theme.badgeColor.inProgress
        case .completed:
            return WishKit.theme.badgeColor.completed
        case .rejected:
            return WishKit.theme.badgeColor.rejected
        }
    }

    private func color(from scheme: ThemeScheme) -> Color {
        switch colorScheme {
        case .light:
            return scheme.light
        case .dark:
            return scheme.dark
        @unknown default:
            return scheme.light
        }
    }
}

extension WishView {
    private static let thumbsUpSystemName = "hand.thumbsup.fill"

    private static let chevronUpSystemName = "chevron.up"

    var upvoteIconImage: some View {
        upvoteIcon.fontWeight(.bold)
    }

    private var upvoteIcon: Image {
        switch WishKit.config.buttons.voteButton.icon {
        case .systemName(let symbolName):
            let trimmedSymbolName = symbolName.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmedSymbolName.isEmpty else {
                return fallbackUpvoteImage(reason: "Received empty upvote symbol name.")
            }

            return Image(systemName: trimmedSymbolName)
        case .thumbsUpIcon:
            return Image(systemName: Self.thumbsUpSystemName)
        case .chevronUpIcon:
            return Image(systemName: Self.chevronUpSystemName)
        }
    }

    private func fallbackUpvoteImage(reason: String) -> Image {
        printDebug(
            WishView.self,
            "Falling back to .chevronUpIcon (\(Self.chevronUpSystemName)). Reason: \(reason)"
        )

        return Image(systemName: Self.chevronUpSystemName)
    }

    var voteTint: Color {
        isVotedByCurrentUser ? WishKit.theme.primaryColor : .primary
    }

    var textColor: Color {
        WishKit.theme.textColor?.resolved(for: colorScheme) ?? .primary
    }

    var backgroundColor: Color {
        WishKit.theme.secondaryColor?.resolved(for: colorScheme) ?? PrivateTheme.elementBackground
    }
}
#endif
