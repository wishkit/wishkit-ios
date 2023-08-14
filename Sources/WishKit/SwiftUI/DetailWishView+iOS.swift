//
//  SwiftUIView.swift
//  
//
//  Created by Martin Lasek on 8/13/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//
#if os(iOS)
import SwiftUI
import WishKitShared
import Combine

struct DetailWishView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @State
    private var isLandscape = false

    private let wishResponse: WishResponse

    public let doneButtonPublisher = PassthroughSubject<Bool, Never>()

    init(wishResponse: WishResponse) {
        self.wishResponse = wishResponse
    }

    var body: some View {
        VStack {

            if isLandscape {
                HStack {
                    Spacer()
                    Button("Done", action: { doneButtonPublisher.send(true) })
                }
            }

            Spacer(minLength: 30)

            WKWishView(title: wishResponse.title, description: wishResponse.description)
            SeparatorView()
                .padding([.top], 15)
            CommentListView(commentList: mockCommentList)
        }
        .padding()
        .background(backgroundColor)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            handleRotation(orientation: UIDevice.current.orientation)
        }
//        .ignoresSafeArea(edges: [.leading, .trailing])
    }

    private func handleRotation(orientation: UIDeviceOrientation) {
        switch orientation {
        case .portrait, .portraitUpsideDown:
            self.isLandscape = false
        case .landscapeLeft, .landscapeRight:
            self.isLandscape = true
        default:
            return
        }
    }

    var mockCommentList: [CommentResponse] {
        return [
            CommentResponse(userId: UUID(), description: "Oh wow..", createdAt: Date(), isAdmin: false),
            CommentResponse(userId: UUID(), description: "This is weird..", createdAt: Date(), isAdmin: true),
            CommentResponse(userId: UUID(), description: "Ah maybe the id?", createdAt: Date(), isAdmin: false),
//            CommentResponse(userId: UUID(), description: "Well in that case", createdAt: Date(), isAdmin: false),
//            CommentResponse(userId: UUID(), description: "Dangerous!", createdAt: Date(), isAdmin: false),
//            CommentResponse(userId: UUID(), description: "Hey! Listen!", createdAt: Date(), isAdmin: true),
//            CommentResponse(userId: UUID(), description: "To go alone..", createdAt: Date(), isAdmin: false),
//            CommentResponse(userId: UUID(), description: "Take this!", createdAt: Date(), isAdmin: false),
        ]
    }
}

// MARK: - Color Scheme

extension DetailWishView {
    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            if let color = WishKit.theme.tertiaryColor {
                return color.light
            }

            return PrivateTheme.systemBackgroundColor.light
        case .dark:
            if let color = WishKit.theme.tertiaryColor {
                return color.dark
            }

            return PrivateTheme.systemBackgroundColor.dark
        }
    }
}

struct DetailWishView_Previews: PreviewProvider {
    static var previews: some View {
        DetailWishView(wishResponse: WishResponse(id: UUID(), userUUID: UUID(), title: "📈 Statistis of my workouts", description: "Seeing a chart showing when and how much I worked out to see my progress in how much more volume I can lift would be really ncie", state: .approved, votingUsers: [UserResponse(uuid: UUID()), UserResponse(uuid: UUID()), UserResponse(uuid: UUID())]))
    }
}
#endif
