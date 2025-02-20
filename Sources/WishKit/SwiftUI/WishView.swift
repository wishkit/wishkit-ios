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
    private var isLoading = false
    
    @Binding
    private var voteCount: Int

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    private let viewKind: ViewKind
    
    private let userUUID = UUIDManager.getUUID()

    private var descriptionLineLimit: Int? {
        if viewKind == .detail {
            return nil
        }
        
        return WishKit.config.expandDescriptionInList ? nil : 3
    }

    private var commentCount: Int? {
        if WishKit.config.commentSection == .show && wishResponse.commentList.count > 0 {
            return wishResponse.commentList.count
        }

        return nil
    }
    
    private var hasVoted: Bool {
        return wishResponse.votingUsers.contains(where: { user in user.uuid == userUUID })
    }
    
    private var hasCommented: Bool {
        return wishResponse.commentList.contains(where: { comment in comment.userId == userUUID })
    }

    init(wishResponse: WishResponse, viewKind: ViewKind, voteActionCompletion: @escaping (() -> Void)) {
        self.wishResponse = wishResponse
        self.viewKind = viewKind
        self.voteActionCompletion = voteActionCompletion
        self._voteCount = .constant(wishResponse.votingUsers.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                Text(wishResponse.title)
                    .foregroundColor(textColor)
                    .font(.system(size: 18, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .lineLimit(viewKind == .list ? 2 : nil)
                
                Spacer()
                
                if viewKind == .list && WishKit.config.statusBadge == .show {
                    Text(wishResponse.state.description.uppercased())
                        .font(.system(size: 11, weight: .semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .foregroundColor(wishResponse.state.badgeColor(for: colorScheme))
                        .background(
                            Capsule()
                                .fill(wishResponse.state.badgeColor(for: colorScheme).opacity(0.15))
                        )
                }
            }
            
            Text(wishResponse.description)
                .foregroundColor(textColor.opacity(0.8))
                .font(.system(size: 14))
                .multilineTextAlignment(.leading)
                .lineLimit(viewKind == .list ? descriptionLineLimit : nil)
            
            HStack(spacing: 16) {
                Button(action: voteAction) {
                    HStack(spacing: 8) {
                        if #available(iOS 17.0, *) {
                            Image(systemName: hasVoted ? "arrow.up.circle.fill" : "arrow.up.circle")
                                .imageScale(.medium)
                                .foregroundColor(hasVoted ? arrowColor : textColor.opacity(0.6))
                                .symbolEffect(.bounce, value: voteCount)
                        } else {
                            Image(systemName: hasVoted ? "arrow.up.circle.fill" : "arrow.up.circle")
                                .imageScale(.medium)
                                .foregroundColor(hasVoted ? arrowColor : textColor.opacity(0.6))
                        }
                        
                        Text(String(describing: voteCount))
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(hasVoted ? arrowColor : textColor.opacity(0.6))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(hasVoted ? arrowColor.opacity(0.15) : Color.primary.opacity(0.05))
                    )
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(isLoading)
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
                
                Spacer()

                if let commentCount = commentCount {
                    HStack {
                        Image(systemName: "ellipsis.bubble")
                            .imageScale(.medium)
                            .foregroundColor(textColor.opacity(0.6))

                        Text(String(describing: commentCount))
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(textColor.opacity(0.6))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.primary.opacity(0.05))
                    )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(backgroundColor)
                .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
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
    }
    
    private func voteAction() {
        withAnimation(.spring(response: 0.3)) {
            isLoading = true
        }
        
        if wishResponse.state == .implemented {
            alertModel.alertReason = .alreadyImplemented
            alertModel.showAlert = true
            return
        }
        
        if (hasVoted) && WishKit.config.allowUndoVote == false {
            alertModel.alertReason = .alreadyVoted
            alertModel.showAlert = true
            return
        }

        let request = VoteWishRequest(wishId: wishResponse.id)
        
        WishApi.voteWish(voteRequest: request) { result in
            isLoading = false
            DispatchQueue.main.async {
                switch result {
                case .success:
                    voteActionCompletion()
                    #if os(iOS)
                    if !hasVoted {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                    #endif
                case .failure(let error):
                    alertModel.alertReason = .voteReturnedError(error.localizedDescription)
                    alertModel.showAlert = true
                }
            }
        }
    }
}

// MARK: - Darkmode

extension WishView {
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

    var textColor: Color {
        switch colorScheme {
        case .light:

            if let color = WishKit.theme.textColor {
                return color.light
            }
            return .black
        case .dark:
            if let color = WishKit.theme.textColor {
                return color.dark
            }

            return .white
        @unknown default:
            if let color = WishKit.theme.textColor {
                return color.light
            }

            return .black
        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:

            if let color = WishKit.theme.secondaryColor {
                return color.light
            }

            return PrivateTheme.elementBackgroundColor.light
        case .dark:
            if let color = WishKit.theme.secondaryColor {
                return color.dark
            }

            return PrivateTheme.elementBackgroundColor.dark
        @unknown default:
            if let color = WishKit.theme.secondaryColor {
                return color.light
            }

            return PrivateTheme.elementBackgroundColor.light
        }
    }
}

extension WishState {
    
    func badgeColor(for colorScheme: ColorScheme) -> Color {
        switch self {
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
        default:
            return .black
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}
