//
//  SwiftUIView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/12/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

final class AlertModel: ObservableObject {

    enum AlertReason {
        case alreadyVoted
        case alreadyImplemented
        case voteReturnedError(String)
        case none
    }

    @Published
    var showAlert = false

    @Published
    var alertReason: AlertReason = .none
}

struct WKWishView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @ObservedObject
    private var alertModel = AlertModel()

    @State
    private var voteCount = 0

    @State
    private var hasVoted = false

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    init(wishResponse: WishResponse, voteActionCompletion: @escaping (() -> Void)) {
        self.wishResponse = wishResponse
        self.voteActionCompletion = voteActionCompletion
        self._voteCount = State(wrappedValue: wishResponse.votingUsers.count)
    }

    var body: some View {
        HStack(spacing: 0) {
            Button(action: voteAction) {
                VStack(spacing: 5) {
                    Image(systemName: "arrowtriangle.up.fill")
                        .foregroundColor(arrowColor)
                    Text(String(describing: voteCount))
                        .foregroundColor(textColor)
                }
                .padding([.leading, .trailing], 20)
                .padding([.top, .bottom], 10)
                .cornerRadius(12)
            }.alert(isPresented: $alertModel.showAlert) {
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
                }

                return Alert(title: title)
            }

            VStack(spacing: 5) {
                HStack {
                    Text(wishResponse.title)
                        .foregroundColor(textColor)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                    Spacer()
                }

                HStack {
                    Text(wishResponse.description)
                        .foregroundColor(textColor)
                        .font(.system(size: 13))
                    Spacer()
                }
            }
        }
        .padding([.top, .bottom, .trailing], 15)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .wkShadow()
    }

    private func voteAction() {
        let userUUID = UUIDManager.getUUID()

        if wishResponse.state == .implemented {
            alertModel.alertReason = .alreadyImplemented
            alertModel.showAlert = true
            return
        }

        if wishResponse.votingUsers.contains(where: { user in user.uuid == userUUID }) || hasVoted {
            alertModel.alertReason = .alreadyVoted
            alertModel.showAlert = true
            return
        }

        let request = VoteWishRequest(wishId: wishResponse.id)
        WishApi.voteWish(voteRequest: request) { result in
            switch result {
            case .success:
                voteCount += 1
                hasVoted = true
                voteActionCompletion()
            case .failure(let error):
                alertModel.alertReason = .voteReturnedError(error.localizedDescription)
                alertModel.showAlert = true
            }
        }
    }
}

extension WKWishView {
    var arrowColor: Color {
        let userUUID = UUIDManager.getUUID()
        if wishResponse.votingUsers.contains(where: { user in user.uuid == userUUID }) || hasVoted {
            return WishKit.theme.primaryColor
        }

        switch colorScheme {
        case .light:
            return WishKit.config.buttons.voteButton.arrowColor.light
        case .dark:
            return WishKit.config.buttons.voteButton.arrowColor.dark
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
        }
    }
}
