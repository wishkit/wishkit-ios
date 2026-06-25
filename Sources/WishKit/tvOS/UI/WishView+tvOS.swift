//
//  WishView+tvOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/14/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(tvOS)
import SwiftUI
import WishKitShared

struct WishView: View {

    @ObservedObject
    private var alertModel = AlertModel()

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
        .alert(isPresented: $alertModel.showAlert) {
            Alert(title: voteAlertTitle)
        }
    }

    private var voteAlertTitle: Text {
        switch alertModel.alertReason {
        case .alreadyVoted:
            return Text(WishKit.config.localization.youCanOnlyVoteOnce)
        case .alreadyCompleted:
            return Text(WishKit.config.localization.youCanNotVoteForACompletedWish)
        case .voteReturnedError(let error):
            return Text("Something went wrong during your vote. Try again later.\n\n\(error)")
        default:
            return Text("Something went wrong during your vote. Try again later.")
        }
    }

    private var listContent: some View {
        HStack(alignment: .center, spacing: 16) {
            voteChip
            VStack(alignment: .leading, spacing: 4) {
                Text(wishResponse.title)
                    .font(.headline)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)

                Text(wishResponse.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }

    private var detailContent: some View {
        HStack(alignment: .center, spacing: 32) {
            voteButtonDetail

            VStack(alignment: .leading, spacing: 16) {
                Text(wishResponse.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(wishResponse.description)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var voteChip: some View {
        VStack(spacing: 4) {
            Image(systemName: "arrowtriangle.up.fill")
            Text("\(voteCount)")
                .font(.subheadline.weight(.semibold))
        }
        .frame(minWidth: 56, minHeight: 56)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .foregroundColor(.white)
        .background(voteChipBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .compositingGroup()
        .drawingGroup()
    }

    private var voteChipBackground: Color {
        isVotedByCurrentUser ? WishKit.theme.primaryColor : Color.gray.opacity(0.6)
    }

    private var voteButtonDetail: some View {
        Button(action: voteAction) {
            VoteButtonDetailLabel(voteCount: voteCount, isVoting: isVoting)
        }
        .buttonStyle(.borderedProminent)
        .tint(isVotedByCurrentUser ? WishKit.theme.primaryColor : .gray)
        .disabled(isVoting)
    }

    private var serverHasVotedByCurrentUser: Bool {
        let currentUserUUID = UUIDManager.getUUID()
        return wishResponse.votingUsers.contains { user in
            user.uuid == currentUserUUID
        }
    }

    private func voteAction() {
        guard !isVoting else { return }

        if wishResponse.state == .implemented || wishResponse.state == .completed {
            alertModel.alertReason = .alreadyCompleted
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
            let request = VoteWishRequest(wishId: wishResponse.id)
            let result = await WishService.voteWish(voteRequest: request)
            guard !Task.isCancelled else { return }

            isVoting = false

            switch result {
            case .success:
                isVotedByCurrentUser = voteDelta > 0
                voteCount += voteDelta
                voteActionCompletion()
            case .failure(let error):
                alertModel.alertReason = .voteReturnedError(error.localizedDescription)
                alertModel.showAlert = true
            }
        }
    }
}

private struct VoteButtonDetailLabel: View {

    let voteCount: Int

    let isVoting: Bool

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "arrowtriangle.up.fill")
                .font(.title2)
                .opacity(isVoting ? 0 : 1)
            Text("\(voteCount)")
                .font(.title3.weight(.semibold))
                .opacity(isVoting ? 0 : 1)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .overlay {
            if isVoting {
                ProgressView()
                    .controlSize(.small)
            }
        }
    }
}
#endif
