//
//  WishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/12/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

@available(iOS 15.0, *)
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

    private var isCompleted: Bool {
        wishResponse.state == .completed || wishResponse.state == .implemented
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
                        if #available(iOS 17.0, macOS 14.0, *) {
                            Image(systemName: voteIconName)
                                .imageScale(.medium)
                                .foregroundStyle(voteColor)
                                .symbolEffect(.bounce, value: voteCount)
                        } else {
                            Image(systemName: voteIconName)
                                .imageScale(.medium)
                                .foregroundStyle(voteColor)
                        }

                        Text(String(describing: voteCount))
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(voteColor)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(isCompleted ? Color.gray.opacity(0.1) : (hasVoted ? arrowColor.opacity(0.15) : Color.primary.opacity(0.05)))
                    )
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(isLoading || isCompleted)
                
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
            let title: Text = switch alertModel.alertReason {
            case .alreadyVoted:
                Text(WishKit.config.localization.youCanOnlyVoteOnce)
            case .voteReturnedError(let error):
                Text("Something went wrong during your vote. Try again later.\n\n\(error)")
            default:
                Text(WishKit.config.localization.youCanNotVoteForYourOwnWish)
            }
            return Alert(title: title)
        }
    }
    
    private var voteIconName: String {
        if isCompleted { return "checkmark.circle.fill" }
        return hasVoted ? "arrow.up.circle.fill" : "arrow.up.circle"
    }

    private var voteColor: Color {
        if isCompleted { return .gray }
        return hasVoted ? arrowColor : textColor.opacity(0.6)
    }

    private func voteAction() {
        guard !isCompleted else { return }

        withAnimation(.spring(response: 0.3)) {
            isLoading = true
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

@available(iOS 15.0, *)
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

    private var badgeScheme: Theme.Scheme {
        let badge = WishKit.theme.badgeColor
        switch self {
        case .approved:     return badge.approved
        case .implemented:  return badge.implemented
        case .pending:      return badge.pending
        case .inReview:     return badge.inReview
        case .planned:      return badge.planned
        case .inProgress:   return badge.inProgress
        case .completed:    return badge.completed
        case .rejected:     return badge.rejected
        default:            return .setBoth(to: .primary)
        }
    }

    func badgeColor(for colorScheme: ColorScheme) -> Color {
        badgeScheme.resolved(for: colorScheme)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}
