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

extension View {
    // MARK: Public - Wrap in Navigation

    public func withNavigation() -> some View {
        NavigationView {
            self
        }.navigationViewStyle(.stack)
    }
}

struct WishlistViewIOS: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @Environment(\.presentationMode)
    private var presentationMode

    @StateObject
    private var viewModel = WishlistViewModel()

    @ObservedObject
    var wishModel: WishModel

    @State
    var selectedWish: WishResponse? = nil

    @State
    private var isInTabBar = false

    private func resolveTabBarPresence() {
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

        isInTabBar = rootViewController is UITabBarController
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

    private var currentList: [WishResponse] {
        viewModel.list(for: wishModel)
    }

    var body: some View {
        ZStack {

            if wishModel.isLoading && !wishModel.hasFetched {
                ProgressView()
                    .imageScale(.large)
            }

            if wishModel.hasFetched && !wishModel.isLoading && currentList.isEmpty {
                Text("\(viewModel.selectedWishState.description): \(WishKit.config.localization.noFeatureRequests)")
            }

            ScrollView {
                VStack {

                    WishlistSegmentedControlSectionView(
                        selectedWishState: $viewModel.selectedWishState,
                        feedbackStateSelection: viewModel.feedbackStateSelection,
                        countProvider: { state in
                            viewModel.count(for: state, wishModel: wishModel)
                        }
                    )

                    Spacer(minLength: 15)

                    if !currentList.isEmpty {
                        ForEach(currentList) { wish in
                            NavigationLink(destination: {
                                DetailWishView(wishResponse: wish, voteActionCompletion: { wishModel.fetchList() })
                            }, label: {
                                WishView(wishResponse: wish, viewKind: .list, voteActionCompletion: { wishModel.fetchList() })
                                    .padding(.all, 5)
                                    .frame(maxWidth: 700)
                            })
                        }.transition(.opacity)
                    }
                }

                Spacer(minLength: isInTabBar ? 100 : 25)
            }
            .refreshableCompat(action: { await wishModel.fetchListAsync() })
            .padding([.leading, .bottom, .trailing])


            WishlistFloatingAddButtonView(
                isVisible: WishKit.config.buttons.addButton.location == .floating,
                isAddButtonShown: WishKit.config.buttons.addButton.display == .show,
                addButtonBottomPadding: addButtonBottomPadding,
                createActionCompletion: { wishModel.fetchList() }
            )
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .ignoresSafeArea(edges: [.leading, .bottom, .trailing])
        .navigationTitle(WishKit.config.localization.featureWishlist)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItem(placement: .topBarLeading) {
                getRefreshButton()
            }

            ToolbarItem(placement: .topBarTrailing) {
                WishlistNavigationBarActionsView(
                    isDoneButtonVisible: WishKit.config.buttons.doneButton.display == .show,
                    isNavigationBarAddVisible: WishKit.config.buttons.addButton.location == .navigationBar,
                    dismissAction: { presentationMode.wrappedValue.dismiss() },
                    createActionCompletion: { wishModel.fetchList() }
                )
            }
        }
        .onAppear {
            resolveTabBarPresence()
            wishModel.fetchList()
        }
    }

    // MARK: - View

    func getRefreshButton() -> AnyView {
        if #unavailable(iOS 15) {
            return AnyView(Button(action: wishModel.fetchList) {
                Image(systemName: "arrow.clockwise")
            })
        } else {
            return AnyView(EmptyView())
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

    var cellBackgroundColor: Color {
        switch colorScheme {
        case .light:
            WishKit.theme.secondaryColor?.light ?? PrivateTheme.elementBackgroundColor.light
        case .dark:
            WishKit.theme.secondaryColor?.dark ?? PrivateTheme.elementBackgroundColor.dark
        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            WishKit.theme.tertiaryColor?.light ?? PrivateTheme.systemBackgroundColor.light
        case .dark:
            WishKit.theme.tertiaryColor?.dark ?? PrivateTheme.systemBackgroundColor.dark
        }
    }
}
#endif
