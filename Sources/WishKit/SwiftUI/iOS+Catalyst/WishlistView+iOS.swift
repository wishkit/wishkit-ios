//
//  SwiftUIView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/15/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//
#if os(iOS)
import SwiftUI
import WishKitShared
import Combine

/// Wraps the content in a NavigationView for iOS but not for Catalyst.
struct WishListContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        #if targetEnvironment(macCatalyst)
            content
        #else
            if UIDevice.current.userInterfaceIdiom == .pad {
                content
            } else {
                NavigationView {
                    content
                }
            }
        #endif
    }
}

struct WishlistViewIOS: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @Environment (\.presentationMode)
    var presentationMode

    @State
    private var selectedWishState: WishState = .approved

    @ObservedObject
    var wishModel: WishModel

    @State
    var selectedWish: WishResponse? = nil

    @State
    private var isShowingCreateView = false

    @State
    private var currentWishList: [WishResponse] = []

    private var isInTabBar: Bool {
        let rootViewController = if #available(iOS 15, *) {
            UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first?
                .rootViewController
        } else {
            UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController
        }

        return rootViewController is UITabBarController
    }

    private var addButtonBottomPadding: CGFloat {
        let basePadding: CGFloat = isInTabBar ? 80 : 30
        switch WishKit.config.buttons.addButton.bottomPadding {
        case .small:
            return basePadding + 15
        case .medium:
            return basePadding + 30
        case .large:
            return basePadding + 60
        }
    }

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

    var body: some View {
        WishListContainer {
            ZStack {

                if wishModel.isLoading && !wishModel.hasFetched {
                    ProgressView()
                        .imageScale(.large)
                }

                if wishModel.hasFetched && !wishModel.isLoading && getList().isEmpty {
                    Text(WishKit.config.localization.noFeatureRequests)
                }

                ScrollView {
                    VStack {

                        if WishKit.config.buttons.segmentedControl.display == .show {
                            Spacer(minLength: 15)

                            SegmentedView(selectedWishState: $selectedWishState)
                                .frame(maxWidth: 200)
                        }

                        Spacer(minLength: 15)

                        ForEach(getList()) { wish in
                            NavigationLink(destination: {
                                DetailWishView(wishResponse: wish, voteActionCompletion: { wishModel.fetchList() })
                            }, label: {
                                WishViewiOS(wishResponse: wish, viewKind: .list, voteActionCompletion: { wishModel.fetchList() })
                                    .padding(.all, 5)
                                    .frame(maxWidth: 700)
                            })
                        }
                    }

                    Spacer(minLength: isInTabBar ? 100 : 25)
                }.refreshableCompat(action: { await wishModel.fetchList() })
                    .padding([.leading, .bottom, .trailing])
                    .frame(maxWidth: .infinity)

                HStack {
                    Spacer()

                    VStack(alignment: .trailing) {
                        Spacer()

                        NavigationLink(isActive: $isShowingCreateView, destination: {
                            WKCreateWishView(isShowing: $isShowingCreateView, createActionCompletion: { wishModel.fetchList() })
                        }, label: {
                            VStack {
                                Image(systemName: "plus")
                                    .foregroundColor(addButtonTextColor)
                            }
                            .frame(width: 60, height: 60)
                            .background(WishKit.theme.primaryColor)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(1/4), radius: 3, x: 0, y: 3)
                            .padding(.bottom, addButtonBottomPadding)
                        })
                    }.padding(.trailing, 20)
                }.frame(maxWidth: 700)
            }
            .background(backgroundColor)
            .ignoresSafeArea(edges: [.leading, .bottom, .trailing])
            .navigationTitle(WishKit.config.localization.featureWishlist)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {
                    getRefreshButton()
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if !isInTabBar {
                        Button(WishKit.config.localization.done) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }.onAppear(perform: wishModel.fetchList)
    }

    // MARK: - View

    func getRefreshButton() -> some View {
        if #unavailable(iOS 15) {
            return Button(action: wishModel.fetchList) {
                Image(systemName: "arrow.clockwise")
            }
        } else {
            return EmptyView()
        }
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

    var addButtonTextColor: Color {
        switch colorScheme {
        case .light:
            return WishKit.config.buttons.addButton.textColor.light
        case .dark:
            return WishKit.config.buttons.addButton.textColor.dark
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
