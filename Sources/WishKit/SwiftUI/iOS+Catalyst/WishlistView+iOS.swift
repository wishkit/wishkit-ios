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

extension View {
    // MARK: Public - Wrap in Navigation

    @ViewBuilder
    public func withNavigation() -> some View {
        NavigationView {
            self
        }.navigationViewStyle(.stack)
    }
}

enum LocalWishState: Hashable, Identifiable {
    case all
    case library(WishState)

    var id: String { description }

    var description: String {
        switch self {
        case .all:
            return WishKit.config.localization.all
        case .library(let wishState):
            return wishState.description
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}

extension Configuration.StatusFilter {
    func toLocalWishState() -> LocalWishState {
        switch self {
        case .all:
            return .all
        case .pending:
            return .library(.pending)
        case .inReview:
            return .library(.inReview)
        case .planned:
            return .library(.planned)
        case .inProgress:
            return .library(.inProgress)
        case .completed:
            return .library(.completed)
        }
    }
}

struct WishlistViewIOS: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @State
    private var selectedWishState: LocalWishState = WishKit.config.defaultStatusFilter.toLocalWishState()

    @ObservedObject
    var wishModel: WishModel

    @State
    var selectedWish: WishResponse? = nil

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

    private var feedbackStateSelection: [LocalWishState] {
        return [
            .all,
            .library(.pending),
            .library(.inReview),
            .library(.planned),
            .library(.inProgress),
            .library(.completed),
        ]
    }

    private func getList() -> [WishResponse] {
        switch selectedWishState {
        case .all:
            return wishModel.all
        case .library(let state):
            switch state {
            case .pending:
                return wishModel.pendingList
            case .inReview, .approved:
                return wishModel.inReviewList
            case .planned:
                return wishModel.plannedList
            case .inProgress:
                return wishModel.inProgressList
            case .completed, .implemented:
                return wishModel.completedList
            case .rejected:
                return []
            }
        }
    }

    private func getCountFor(state: LocalWishState) -> Int {
        switch state {
        case .all:
            return wishModel.all.count
        case .library(let wishState):
            switch wishState {
            case .pending:
                return wishModel.pendingList.count
            case .inReview, .approved:
                return wishModel.inReviewList.count
            case .planned:
                return wishModel.plannedList.count
            case .inProgress:
                return wishModel.inProgressList.count
            case .completed, .implemented:
                return wishModel.completedList.count
            case .rejected:
                return 0
            }
        }
    }

    var body: some View {
        ZStack {

            if wishModel.isLoading && !wishModel.hasFetched {
                ProgressView()
                    .imageScale(.large)
            }

            if wishModel.hasFetched && !wishModel.isLoading && getList().isEmpty {
                Text("\(selectedWishState.description): \(WishKit.config.localization.noFeatureRequests)")
            }

            ScrollView {
                VStack {

                    if WishKit.config.buttons.segmentedControl.display == .show {
                        Spacer(minLength: 15)

                        Picker("", selection: $selectedWishState) {
                            ForEach(feedbackStateSelection, id: \.self) { state in
                                Text("\(state.description) (\(getCountFor(state: state)))")
                                    .tag(state)
                            }
                        }
                    }

                    Spacer(minLength: 15)

                    if getList().count > 0 {
                        ForEach(getList()) { wish in
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
            .refreshableCompat(action: { await wishModel.fetchList() })
            .padding([.leading, .bottom, .trailing])


            if WishKit.config.buttons.addButton.location == .floating {
                HStack {
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        VStack {
                            Spacer()
                            
                            if WishKit.config.buttons.addButton.display == .show {
                                NavigationLink(
                                    destination: {
                                        CreateWishView(createActionCompletion: { wishModel.fetchList() })
                                    }, label: {
                                        AddButton(size: CGSize(width: 60, height: 60))
                                    }
                                )
                            }
                        }.padding(.bottom, addButtonBottomPadding)
                    }.padding(.trailing, 20)
                }.frame(maxWidth: 700)
            }
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
                if WishKit.config.buttons.doneButton.display == .show {
                    Button(WishKit.config.localization.done) {
                        UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController?.dismiss(animated: true)
                    }
                }
                
                if WishKit.config.buttons.addButton.location == .navigationBar {
                    NavigationLink(
                        destination: {
                            CreateWishView(createActionCompletion: { wishModel.fetchList() })
                        }, label: {
                            Text(WishKit.config.localization.addButtonInNavigationBar)
                        }
                    )
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
