//
//  WishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/12/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

struct WishView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @ObservedObject
    private var alertModel = AlertModel()

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

    private let viewKind: WishViewKind

    private var descriptionLineLimit: Int? {
        if viewKind == .detail {
            return nil
        }

        return WishKit.config.expandDescriptionInList ? nil : 1
    }

    init(wishResponse: WishResponse, viewKind: WishViewKind, voteActionCompletion: @escaping (() -> Void)) {
        let currentUserUUID = UUIDManager.getUUID()
        let hasVotedByCurrentUser = wishResponse.votingUsers.contains { user in
            user.uuid == currentUserUUID
        }

        self.wishResponse = wishResponse
        self.viewKind = viewKind
        self.voteActionCompletion = voteActionCompletion
        self._voteCount = .init(initialValue: wishResponse.votingUsers.count)
        self._isVotedByCurrentUser = .init(initialValue: hasVotedByCurrentUser)
    }

    var body: some View {
        HStack(spacing: 0) {
            Button(action: voteAction) {
                VStack(spacing: 5) {
                    upvoteIconImage
                        .renderingMode(.template)
                        .imageScale(.medium)
                        .foregroundColor(arrowColor)
                    voteCountText
                }
                .padding(8)
                .background(voteButtonBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .opacity(voteButtonOpacity)
            }
            .buttonStyle(.plain)
            .padding(.leading, 10)
            .padding(.trailing, 8)
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
            .alert(isPresented: $alertModel.showAlert) {
                Alert(title: voteAlertTitle)
            }

            VStack(spacing: 5) {
                HStack {
                    Text(wishResponse.title)
                        .foregroundColor(textColor)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(viewKind == .list ? 1 : nil)

                    Spacer()

                    if viewKind == .list && WishKit.config.statusBadge == .show {
                        Text(wishResponse.state.description.uppercased())
                            .opacity(0.8)
                            .font(.system(size: 10, weight: .medium))
                            .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                            .foregroundColor(.primary)
                            .background(badgeColor(for: wishResponse.state).opacity(1 / 3))
                            .cornerRadius(6)
                    }
                }

                HStack {
                    Text(wishResponse.description)
                        .foregroundColor(textColor)
                        .font(.system(size: 13))
                        .multilineTextAlignment(.leading)
                        .lineLimit(descriptionLineLimit)
                    Spacer()
                }
            }
        }
        .padding([.top, .bottom, .trailing], 10)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
        .wkShadow()
    }

    func badgeColor(for wishState: WishState) -> Color {
        color(from: badgeScheme(for: wishState))
    }

    private func voteAction() {
        guard isVoting == false else {
            return
        }

        if wishResponse.state == .implemented {
            alertModel.alertReason = .alreadyImplemented
            alertModel.showAlert = true
            return
        }

        if isVotedByCurrentUser && WishKit.config.allowUndoVote == false {
            alertModel.alertReason = .alreadyVoted
            alertModel.showAlert = true
            return
        }

        let voteDelta = isVotedByCurrentUser ? -1 : 1
        isVoting = true

        voteTask?.cancel()
        voteTask = Task { @MainActor in
            let requestStartedAt = Date()
            let request = VoteWishRequest(wishId: wishResponse.id)
            let result = await WishApi.voteWish(voteRequest: request)
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
                alertModel.alertReason = .voteReturnedError(error.localizedDescription)
                alertModel.showAlert = true
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

    @ViewBuilder
    private var voteCountText: some View {
        let base = Text(String(describing: voteCount))
            .font(.footnote.weight(.semibold))
            .foregroundColor(textColor)
            .frame(minWidth: 35)
            .scaleEffect(voteCountScale)

        if #available(iOS 17.0, macOS 14.0, *) {
            base.contentTransition(.numericText(value: Double(voteCount)))
        } else {
            base
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

    private var voteAlertTitle: Text {
        switch alertModel.alertReason {
        case .alreadyVoted:
            return Text(WishKit.config.localization.youCanOnlyVoteOnce)
        case .alreadyImplemented:
            return Text(WishKit.config.localization.youCanNotVoteForAnImplementedWish)
        case .voteReturnedError(let error):
            return Text("Something went wrong during your vote. Try again later.\n\n\(error)")
        case .none:
            return Text(WishKit.config.localization.youCanNotVoteForYourOwnWish)
        default:
            return Text("Something went wrong during your vote. Try again later.")
        }
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

    private static let arrowUpvoteSystemName = "arrowtriangle.up.fill"

    var upvoteIconImage: Image {
        switch WishKit.config.buttons.voteButton.icon {
        case .systemName(let symbolName):
            let trimmedSymbolName = symbolName.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmedSymbolName.isEmpty else {
                return fallbackUpvoteImage(reason: "Received empty upvote symbol name.")
            }

            return Image(systemName: trimmedSymbolName)
        case .thumbsUpIcon:
            return Image(systemName: Self.thumbsUpSystemName)
        case .arrowUpvoteIcon:
            return Image(systemName: Self.arrowUpvoteSystemName)
        }
    }

    private func fallbackUpvoteImage(reason: String) -> Image {
        printDebug(
            WishView.self,
            "Falling back to .arrowUpvoteIcon (\(Self.arrowUpvoteSystemName)). Reason: \(reason)"
        )

        return Image(systemName: Self.arrowUpvoteSystemName)
    }

    var arrowColor: Color {
        if isVotedByCurrentUser {
            return WishKit.theme.primaryColor
        }

        switch colorScheme {
        case .light:
            return WishKit.config.buttons.voteButton.arrowColor.light
        case .dark:
            return WishKit.config.buttons.voteButton.arrowColor.dark
        @unknown default:
            return WishKit.config.buttons.voteButton.arrowColor.light
        }
    }

    var voteButtonBackgroundColor: Color {
        switch colorScheme {
        case .light:
            return arrowColor.opacity(0.12)
        case .dark:
            return arrowColor.opacity(0.2)
        @unknown default:
            return arrowColor.opacity(0.12)
        }
    }

    var textColor: Color {
        switch colorScheme {
        case .light:
            WishKit.theme.textColor?.light ?? .black
        case .dark:
            WishKit.theme.textColor?.dark ?? .white
        @unknown default:
            WishKit.theme.textColor?.light ?? .black
        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            WishKit.theme.secondaryColor?.light ?? PrivateTheme.elementBackgroundColor.light
        case .dark:
            WishKit.theme.secondaryColor?.dark ?? PrivateTheme.elementBackgroundColor.dark
        @unknown default:
            WishKit.theme.secondaryColor?.light ?? PrivateTheme.elementBackgroundColor.light
        }
    }
}
