//
//  WishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/5/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

struct WishView: View {

    enum AlertReason {
        case alreadyVoted
        case alreadyImplemented
        case voteReturnedError
        case none
    }

    @Environment(\.colorScheme)
    var colorScheme

    @State
    private var showAlert: Bool = false

    @State
    private var alertReason: AlertReason = .none

    private let wish: WishResponse

    private let voteCompletion: () -> ()

    init(wish: WishResponse, voteCompletion: @escaping () -> ()) {
        self.wish = wish
        self.voteCompletion = voteCompletion
    }

    func hasUserVoted() -> Bool {
        return wish.votingUsers.contains(where: { user in user.uuid == UUIDManager.getUUID() })
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
            case .success(let success):
                voteCompletion()
            case .failure(let failure):
                alertReason = .voteReturnedError
                showAlert = true
            }
        }
    }

    var body: some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)

            HStack {
                Button(action: vote) {
                    VStack(alignment: .center, spacing: 3) {
                        if hasUserVoted() {
                            Image(systemName: "triangle.fill")
                                .foregroundColor(WishKit.theme.primaryColor)
                        } else {
                            Image(systemName: "triangle.fill")
                        }
                        Text(wish.votingUsers.count.description)
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                }.buttonStyle(BorderlessButtonStyle())

                VStack(alignment: .leading, spacing: 5) {
                    Text(wish.title)
                        .bold()
                        .truncationMode(.tail)
                        .lineLimit(1)
                    Text(wish.description)
                        .truncationMode(.tail)
                        .lineLimit(1)
                }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                Spacer()
            }
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
        }.alert(String("Info"), isPresented: $showAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            switch alertReason {
            case .alreadyVoted:
                Text("You can only vote once.")
            case .alreadyImplemented:
                Text("You can not vote for a wish that is already implemented.")
            case .voteReturnedError:
                Text("Something went wrong during your vote. Try again later..")
            case .none:
                Text("You can not vote for this wish.")
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
