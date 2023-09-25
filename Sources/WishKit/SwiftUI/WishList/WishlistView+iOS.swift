//
//  SwiftUIView.swift
//  
//
//  Created by Martin Lasek on 9/15/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//
#if os(iOS)
import SwiftUI
import WishKitShared
import Combine

struct WishlistViewIOS: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @State
    private var selectedWishState: WishState = .approved

    @ObservedObject
    var wishModel: WishModel

    @State
    var selectedWish: WishResponse? = nil

    @State
    private var isLandscape = false

    // MARK: - Public

    public let doneButtonPublisher = PassthroughSubject<Bool, Never>()

    private func getList() -> [WishResponse] {
        switch selectedWishState {
        case .approved:
            return wishModel.approvedWishlist
        case .implemented:
            return wishModel.implementedWishlist
        default:
            return []
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

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    SegmentedView(selectedWishState: $selectedWishState)
                        .frame(maxWidth: 200)

                    if isLandscape {
                        HStack {
                            Spacer()
                            Button(WishKit.config.localization.done, action: { doneButtonPublisher.send(true) })
                        }
                        .frame(maxWidth: 700)
                    }

                    Spacer(minLength: 15)

                    ScrollView {
                        ForEach(getList()) { wish in
                            NavigationLink(destination: {
                                DetailWishView(wishResponse: wish, voteActionCompletion: wishModel.fetchList)
                            }, label: {
                                WKWishView(wishResponse: wish, voteActionCompletion: { print("voted") })
                                    .padding(.all, 5)
                                    .frame(maxWidth: 700)
                            })
                        }
                    }
                }.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    // Handle when phone is rotated to/from landscape.
                    handleRotation(orientation: UIDevice.current.orientation)
                }
                .padding()
                .frame(maxWidth: .infinity)

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
            .background(backgroundColor)
            .ignoresSafeArea(.all)
        }.onAppear(perform: wishModel.fetchList)
    }
}

extension WishlistViewIOS {
    var arrowColor: Color {
        let userUUID = UUIDManager.getUUID()
        if
            let selectedWish = selectedWish,
            selectedWish.votingUsers.contains(where: { user in user.uuid == userUUID })
        {
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

    var cellBackgroundColor: Color {
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

#endif
