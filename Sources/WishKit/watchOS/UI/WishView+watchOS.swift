//
//  WishView+watchOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/13/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(watchOS)
import SwiftUI
import WishKitShared

struct WishView: View {

    @State
    private var voteCount: Int

    @State
    private var isVotedByCurrentUser: Bool

    @State
    private var isVoting = false

    @State
    private var voteTask: Task<Void, Never>?

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    private let viewKind: WishViewKind

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
        Group {
            if viewKind == .detail {
                detailContent
            } else {
                listContent
            }
        }
        .onDisappear {
            voteTask?.cancel()
            voteTask = nil
        }
        .onChange(of: wishResponse.votingUsers.count) { newValue in
            guard isVoting == false else { return }
            voteCount = newValue
        }
        .onChange(of: serverHasVotedByCurrentUser) { newValue in
            guard isVoting == false else { return }
            isVotedByCurrentUser = newValue
        }
    }

    private var serverHasVotedByCurrentUser: Bool {
        let currentUserUUID = UUIDManager.getUUID()
        return wishResponse.votingUsers.contains { user in
            user.uuid == currentUserUUID
        }
    }

    private var listContent: some View {
        HStack(alignment: .center, spacing: 8) {
            voteChip

            VStack(alignment: .leading, spacing: 2) {
                Text(wishResponse.title)
                    .font(.caption2.weight(.semibold))
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)

                Text(wishResponse.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 2)
    }

    private var detailContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(wishResponse.title)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(wishResponse.description)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            voteButtonFullWidth
                .padding(.top, 4)
        }
    }

    private var voteChip: some View {
        Button(action: voteAction) {
            VStack(spacing: 2) {
                Image(systemName: "arrowtriangle.up.fill")
                Text("\(voteCount)")
            }
            .font(.system(size: 12, weight: .semibold))
            .frame(minWidth: 24)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(voteTint.opacity(0.20))
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .foregroundStyle(voteTint)
        }
        .buttonStyle(.plain)
        .disabled(isVoting)
    }

    private var voteButtonFullWidth: some View {
        Button(action: voteAction) {
            HStack(spacing: 6) {
                if isVoting {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Image(systemName: "arrowtriangle.up.fill")
                    Text("\(voteCount)")
                        .font(.caption.weight(.semibold))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(isVotedByCurrentUser ? WishKit.theme.primaryColor : Color.gray.opacity(0.5))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(isVoting)
    }

    private var voteTint: Color {
        isVotedByCurrentUser ? WishKit.theme.primaryColor : .primary
    }

    private func voteAction() {
        guard !isVoting else { return }
        guard wishResponse.state != .implemented else { return }
        if isVotedByCurrentUser && WishKit.config.allowUndoVote == false { return }

        let voteDelta = isVotedByCurrentUser ? -1 : 1
        isVoting = true

        voteTask?.cancel()
        voteTask = Task { @MainActor in
            let request = VoteWishRequest(wishId: wishResponse.id)
            let result = await WishService.voteWish(voteRequest: request)
            guard !Task.isCancelled else { return }

            isVoting = false

            switch result {
            case .success:
                isVotedByCurrentUser = voteDelta > 0
                voteCount += voteDelta
                voteActionCompletion()
            case .failure:
                break
            }
        }
    }
}
#endif
