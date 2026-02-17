//
//  WishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/12/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

struct WishView: View {

    // Helps differentiate where this view is used (in the list or in detail view).
    enum ViewKind {
        case list
        case detail
    }

    @Environment(\.colorScheme)
    private var colorScheme

    @ObservedObject
    private var alertModel = AlertModel()

    @State
    private var voteCount: Int

    @State
    private var isVoting = false

    @State
    private var voteCountScale: CGFloat = 1

    @State
    private var voteButtonOpacity: CGFloat = 1

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    private let viewKind: ViewKind

    private var descriptionLineLimit: Int? {
        if viewKind == .detail {
            return nil
        }
        
        return WishKit.config.expandDescriptionInList ? nil : 1
    }

    init(wishResponse: WishResponse, viewKind: ViewKind, voteActionCompletion: @escaping (() -> Void)) {
        self.wishResponse = wishResponse
        self.viewKind = viewKind
        self.voteActionCompletion = voteActionCompletion
        self._voteCount = .init(initialValue: wishResponse.votingUsers.count)
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
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(voteButtonBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .opacity(voteButtonOpacity)
            }
            .buttonStyle(.plain) // makes sure it looks good on macOS.
            .padding(8)
            .disabled(isVoting)
            .onChange(of: isVoting) { newValue in
                if newValue {
                    startVoteButtonHeartbeat()
                } else {
                    stopVoteButtonHeartbeat()
                }
            }
            .onDisappear {
                stopVoteButtonHeartbeat()
            }
            .alert(isPresented: $alertModel.showAlert) {
                var title = Text(WishKit.config.localization.youCanNotVoteForYourOwnWish)
                switch alertModel.alertReason {
                case .alreadyVoted:
                    title = Text(WishKit.config.localization.youCanOnlyVoteOnce)
                case .alreadyImplemented:
                    title = Text(WishKit.config.localization.youCanNotVoteForAnImplementedWish)
                case .voteReturnedError(let error):
                    title = Text("Something went wrong during your vote. Try again later.\n\n\(error)")
                case .none:
                    title = Text(WishKit.config.localization.youCanNotVoteForYourOwnWish)
                default:
                    title = Text("Something went wrong during your vote. Try again later.")
                }

                return Alert(title: title)
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
                            .background(badgeColor(for: wishResponse.state).opacity(1/3))
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
        switch wishState {
        case .approved:
            switch colorScheme {
            case .light:
                return WishKit.theme.badgeColor.approved.light
            case .dark:
                return WishKit.theme.badgeColor.approved.dark
            @unknown default:
                return WishKit.theme.badgeColor.approved.light
            }
        case .implemented:
            switch colorScheme {
            case .light:
                return WishKit.theme.badgeColor.implemented.light
            case .dark:
                return WishKit.theme.badgeColor.implemented.dark
            @unknown default:
                return WishKit.theme.badgeColor.implemented.light
            }

        case .pending:
            switch colorScheme {
            case .light:
                return WishKit.theme.badgeColor.pending.light
            case .dark:
                return WishKit.theme.badgeColor.pending.dark
            @unknown default:
                return WishKit.theme.badgeColor.pending.light
            }
        case .inReview:
            switch colorScheme {
            case .light:
                return WishKit.theme.badgeColor.inReview.light
            case .dark:
                return WishKit.theme.badgeColor.inReview.dark
            @unknown default:
                return WishKit.theme.badgeColor.inReview.light
            }
        case .planned:
            switch colorScheme {
            case .light:
                return WishKit.theme.badgeColor.planned.light
            case .dark:
                return WishKit.theme.badgeColor.planned.dark
            @unknown default:
                return WishKit.theme.badgeColor.planned.light
            }
        case .inProgress:
            switch colorScheme {
            case .light:
                return WishKit.theme.badgeColor.inProgress.light
            case .dark:
                return WishKit.theme.badgeColor.inProgress.dark
            @unknown default:
                return WishKit.theme.badgeColor.inProgress.light
            }

        case .completed:
            switch colorScheme {
            case .light:
                return WishKit.theme.badgeColor.completed.light
            case .dark:
                return WishKit.theme.badgeColor.completed.dark
            @unknown default:
                return WishKit.theme.badgeColor.completed.light
            }
        case .rejected:
            switch colorScheme {
            case .light:
                return WishKit.theme.badgeColor.rejected.light
            case .dark:
                return WishKit.theme.badgeColor.rejected.dark
            @unknown default:
                return WishKit.theme.badgeColor.rejected.light
            }
        }
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
        
        let userUUID = UUIDManager.getUUID()
        
        let hasVoted = wishResponse.votingUsers.contains(where: { user in user.uuid == userUUID })
        
        if (hasVoted) && WishKit.config.allowUndoVote == false {
            alertModel.alertReason = .alreadyVoted
            alertModel.showAlert = true
            return
        }

        let request = VoteWishRequest(wishId: wishResponse.id)
        let requestStartedAt = Date()
        isVoting = true
        
        WishApi.voteWish(voteRequest: request) { result in
            Task { @MainActor in
                let minimumPulseDuration: TimeInterval = 0.45
                let elapsed = Date().timeIntervalSince(requestStartedAt)
                if elapsed < minimumPulseDuration {
                    let remaining = minimumPulseDuration - elapsed
                    try? await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000))
                }

                isVoting = false
                switch result {
                case .success:
                    let voteDelta = hasVoted && WishKit.config.allowUndoVote ? -1 : 1
                    applyVoteSuccessAnimations(voteDelta: voteDelta)
                    voteActionCompletion()
                case .failure(let error):
                    alertModel.alertReason = .voteReturnedError(error.localizedDescription)
                    alertModel.showAlert = true
                }
            }
        }
    }

    private func applyVoteSuccessAnimations(voteDelta: Int) {
        guard voteDelta != 0 else {
            return
        }

        withAnimation(.easeOut(duration: 0.2)) {
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
}

// MARK: - Darkmode

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

            guard isValidSystemSymbolName(trimmedSymbolName) else {
                return fallbackUpvoteImage(reason: "Received invalid SF Symbol '\(trimmedSymbolName)'.")
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

    private func isValidSystemSymbolName(_ symbolName: String) -> Bool {
        #if canImport(UIKit)
        return UIImage(systemName: symbolName) != nil
        #elseif canImport(AppKit)
        return NSImage(
            systemSymbolName: symbolName,
            accessibilityDescription: nil
        ) != nil
        #else
        return false
        #endif
    }

    var arrowColor: Color {
        let userUUID = UUIDManager.getUUID()
        if wishResponse.votingUsers.contains(where: { user in user.uuid == userUUID }) {
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
