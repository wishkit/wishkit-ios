//
//  SwiftUIView.swift
//  wishkit-ios
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

    @State
    private var newCommentValue = ""

    @State
    private var commentList: [CommentResponse] = []

    private let wishResponse: WishResponse

    public let doneButtonPublisher = PassthroughSubject<Bool, Never>()

    init(wishResponse: WishResponse) {
        self.wishResponse = wishResponse
        self._commentList = State(wrappedValue: wishResponse.commentList)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack {

                    if isLandscape {
                        HStack {
                            Spacer()
                            Button("Done", action: { doneButtonPublisher.send(true) })
                        }
                        .frame(maxWidth: 700)
                    }

                    Spacer(minLength: 15)

                    WKWishView(wishResponse: wishResponse)
                        .frame(maxWidth: 700)

                    Spacer(minLength: 15)

                    SeparatorView()
                        .padding([.top, .bottom], 15)

                    CommentFieldView($newCommentValue) {
                        let request = CreateCommentRequest(wishId: wishResponse.id, description: newCommentValue)

                        let response = await CommentApi.createComment(request: request)

                        switch response {
                        case .success(let commentResponse):
                            withAnimation {
                                commentList.insert(commentResponse, at: 0)
                            }

                            newCommentValue = ""
                        case .failure(let error):
                            print("❌ \(error.localizedDescription)")
                        }
                    }.frame(maxWidth: 700)

                    Spacer(minLength: 20)

                    CommentListView(commentList: $commentList)
                        .frame(maxWidth: 700)
                }
                .padding()
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    // Handle when phone is rotated to/from landscape.
                    handleRotation(orientation: UIDevice.current.orientation)
                }
            }
            .background(backgroundColor)
            .ignoresSafeArea(edges: [.bottom, .leading, .trailing])

            // Handle when app is launched in landscape.
            GeometryReader { proxy in
                VStack {}
                    .onAppear {
                        if proxy.size.width > proxy.size.height {
                            self.isLandscape = true
                        } else {
                            self.isLandscape = false
                        }
                    }
            }
        }
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
        DetailWishView(wishResponse: WishResponse(id: UUID(), userUUID: UUID(), title: "📈 Statistis of my workouts", description: "Seeing a chart showing when and how much I worked out to see my progress in how much more volume I can lift would be really ncie", state: .approved, votingUsers: [UserResponse(uuid: UUID()), UserResponse(uuid: UUID()), UserResponse(uuid: UUID())], commentList: []))
    }
}
#endif
