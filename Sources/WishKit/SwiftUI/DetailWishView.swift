//
//  DetailWishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

#if os(macOS)
struct DetailWishView: View {

    enum AlertReason {
        case alreadyVoted
        case alreadyImplemented
        case voteReturnedError(String)
        case none
    }

    @Environment (\.presentationMode)
    var presentationMode

    @Environment(\.colorScheme)
    var colorScheme

    @State
    private var showAlert: Bool = false

    @State
    private var alertReason: AlertReason = .none

    private var wish: WishResponse

    private var voteCompletion: () -> ()

    public init(wish: WishResponse, voteCompletion: @escaping () -> ()) {
        self.wish = wish
        self.voteCompletion = voteCompletion
    }

    func vote() {
        let userUUID = UUIDManager.getUUID()

        if wish.state == .implemented {
            alertReason = .alreadyImplemented
            showAlert = true
            return
        }

        if wish.votingUsers.contains(where: { user in user.uuid == userUUID }) {
            alertReason = .alreadyVoted
            showAlert = true
            return
        }

        let request = VoteWishRequest(wishId: wish.id)
        WishApi.voteWish(voteRequest: request) { result in
            switch result {
            case .success:
                self.presentationMode.wrappedValue.dismiss()
                voteCompletion()
            case .failure(let error):
                alertReason = .voteReturnedError(error.localizedDescription)
                showAlert = true
            }
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(backgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 80, trailing: 15))

            VStack {
                HStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text(wish.title).bold().font(.title2)
                            Spacer(minLength: 10)
                            Text(wish.description)
                        }.frame(alignment: .leading)
                    }
                    .padding(EdgeInsets(top: 30, leading: 30, bottom: 20, trailing: 30))
                    Spacer()
                }

                Text("\(WishKit.configuration.localization.votes): \(wish.votingUsers.count)")

                HStack {
                    WKButton(text: WishKit.configuration.localization.close, action: { self.presentationMode.wrappedValue.dismiss() }, style: .secondary)
                    .interactiveDismissDisabled()
                    WKButton(text: WishKit.configuration.localization.upvote, action: vote)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        }.alert(String(WishKit.configuration.localization.info), isPresented: $showAlert) {
            Button(WishKit.configuration.localization.ok, role: .cancel) { }
        } message: {
            switch alertReason {
            case .alreadyVoted:
                Text(WishKit.configuration.localization.youCanOnlyVoteOnce)
            case .alreadyImplemented:
                Text(WishKit.configuration.localization.youCanNotVoteForAnImplementedWish)
            case .voteReturnedError(let error):
                Text("Something went wrong during your vote. Try again later.\n\n\(error)")
            case .none:
                Text(WishKit.configuration.localization.youCanNotVoteForYourOwnWish)
            }

        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            return PrivateTheme.elementBackgroundColor.light
        case .dark:
            return PrivateTheme.elementBackgroundColor.dark
        }
    }
}
#endif
