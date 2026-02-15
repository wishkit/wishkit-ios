//
//  WishlistView+iOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/15/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import WishKitShared
import Combine

// MARK: - Navigation Helper

extension View {
    @ViewBuilder
    public func withNavigation() -> some View {
        NavigationView {
            self
        }.navigationViewStyle(.stack)
    }
}

// MARK: - LocalWishState

enum LocalWishState: Hashable, Identifiable {
    case all
    case library(WishState)

    var id: String { description }

    var description: String {
        switch self {
        case .all:
            return "All".localized()
        case .library(let wishState):
            return wishState.description
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }

    func badgeColor(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .all:
            return .primary
        case .library(let state):
            return state.badgeColor(for: colorScheme)
        }
    }
}

// MARK: - View Mode

enum WishlistViewMode: String {
    case kanban
    case list
}

// MARK: - WishlistViewIOS

struct WishlistViewIOS: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @ObservedObject var wishModel: WishModel

    @AppStorage("wishkit_view_mode")
    private var viewMode: String = WishlistViewMode.kanban.rawValue

    @AppStorage("wishkit_onboarding_seen")
    private var hasSeenOnboarding = false

    private var selectedMode: WishlistViewMode {
        WishlistViewMode(rawValue: viewMode) ?? .kanban
    }

    private var addButtonBottomPadding: CGFloat {
        switch WishKit.config.buttons.addButton.bottomPadding {
        case .small:  return 45
        case .medium: return 60
        case .large:  return 90
        }
    }

    // MARK: - Body

    var body: some View {
        Group {
            if !hasSeenOnboarding {
                RoadmapOnboardingView {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        hasSeenOnboarding = true
                    }
                }
            } else {
                roadmapContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(WishlistColors.background(for: colorScheme))
        .ignoresSafeArea(edges: [.leading, .bottom, .trailing])
        .navigationTitle(WishKit.config.localization.featureWishlist)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if hasSeenOnboarding {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        viewModePicker
                        trailingToolbarContent
                    }
                }
            }
        }
        .onAppear(perform: wishModel.fetchList)
        .toolbar(.hidden, for: .tabBar)
    }

    // MARK: - Roadmap Content

    private var roadmapContent: some View {
        ZStack {
            if wishModel.isLoading && !wishModel.hasFetched {
                ProgressView()
                    .imageScale(.large)
            }

            if wishModel.hasFetched && !wishModel.isLoading && wishModel.all.isEmpty {
                Text(WishKit.config.localization.noFeatureRequests)
            }

            switch selectedMode {
            case .kanban:
                KanbanBoardView(wishModel: wishModel)
            case .list:
                WishListBoardView(wishModel: wishModel)
            }

            floatingAddButton
        }
    }

    // MARK: - Toolbar Picker

    private var viewModePicker: some View {
        Picker("", selection: $viewMode) {
            Image(systemName: "rectangle.split.3x1")
                .tag(WishlistViewMode.kanban.rawValue)
            Image(systemName: "list.bullet")
                .tag(WishlistViewMode.list.rawValue)
        }
        .pickerStyle(.segmented)
        .frame(width: 120)
    }

    // MARK: - Trailing Toolbar

    @ViewBuilder
    private var trailingToolbarContent: some View {
        if WishKit.config.buttons.doneButton.display == .show {
            Button(WishKit.config.localization.done) {
                UIApplication.shared.windows.first(where: \.isKeyWindow)?
                    .rootViewController?.dismiss(animated: true)
            }
        }

        if WishKit.config.buttons.addButton.location == .navigationBar {
            NavigationLink {
                CreateWishView(createActionCompletion: { wishModel.fetchList() })
            } label: {
                Text(WishKit.config.localization.addButtonInNavigationBar)
            }
        }
    }

    // MARK: - Floating Add Button

    @ViewBuilder
    private var floatingAddButton: some View {
        if WishKit.config.buttons.addButton.location == .floating
            && WishKit.config.buttons.addButton.display == .show {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        CreateWishView(createActionCompletion: { wishModel.fetchList() })
                    } label: {
                        AddButton(size: CGSize(width: 60, height: 60))
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, addButtonBottomPadding)
                }
            }
        }
    }
}
#endif
