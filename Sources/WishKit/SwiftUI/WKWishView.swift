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

    enum AlertReason {
        case alreadyVoted
        case alreadyImplemented
        case voteReturnedError(String)
        case none
    }

    @Environment(\.colorScheme)
    var colorScheme

    @ObservedObject
    private var alertModel = AlertModel()

    @State
    var voteCount = 0

    private let wishResponse: WishResponse

    init(wishResponse: WishResponse) {
        self.wishResponse = wishResponse
        self._voteCount = State(wrappedValue: wishResponse.votingUsers.count)
    }

    var body: some View {
        HStack(spacing: 0) {
            Button(action: voteAction) {
                VStack(spacing: 5) {
                    Image(systemName: "arrowtriangle.up.fill")
                    Text(String(describing: voteCount))
                }
                .foregroundColor(textColor)
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
        .shadow(color: .black.opacity(1/5), radius: 4, y: 3)
    }

    private func voteAction() {
        let userUUID = UUIDManager.getUUID()

        if wishResponse.state == .implemented {
            alertModel.alertReason = .alreadyImplemented
            alertModel.showAlert = true
            return
        }

        if wishResponse.votingUsers.contains(where: { user in user.uuid == userUUID }) {
            alertModel.alertReason = .alreadyVoted
            alertModel.showAlert = true
            return
        }

        let request = VoteWishRequest(wishId: wishResponse.id)
        WishApi.voteWish(voteRequest: request) { result in
            switch result {
            case .success(let response):
                voteCount = response.votingUsers.count
            case .failure(let error):
                alertModel.alertReason = .voteReturnedError(error.localizedDescription)
                alertModel.showAlert = true
            }
        }
    }
}

extension WKWishView {
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

struct WKWishView_Previews: PreviewProvider {
    static let wishResponse = WishResponse(
        id: UUID(),
        userUUID: UUID(),
        title: "📈 Statistics of my workouts!",
        description: "Seeing a chart showing when and how much I worked out to see my progress in how much more volume I can list would be really ncie.",
        state: .approved,
        votingUsers: [],
        commentList: []
    )

    static var previews: some View {
        VStack {
            Spacer()
            WKWishView(wishResponse: wishResponse)
                .padding()
            Spacer()
        }.background(Color.red)
    }
}
