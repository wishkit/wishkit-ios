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

struct WishlistViewIOS: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @State
    private var selectedWishState: WishState = .approved

    @ObservedObject
    var wishModel: WishModel

    @State
    var selectedWish: WishResponse? = nil

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
        NavigationView {
            VStack(spacing: 0) {
                SegmentedView(selectedWishState: $selectedWishState)
                    .frame(maxWidth: 200)
                    .padding([.top, .bottom], 15)

                ScrollView {
                    ForEach(getList()) { wish in
                        NavigationLink(destination: {
                            DetailWishView(wishResponse: wish, voteActionCompletion: wishModel.fetchList)
                        }, label: {
                            HStack(spacing: 0) {
                                VStack(spacing: 5) {
                                    Image(systemName: "arrowtriangle.up.fill")
                                        .imageScale(.large)
                                        .foregroundColor(arrowColor)
                                    Text(wish.votingUsers.count.description)
                                        .font(.system(size: 17))
                                        .foregroundColor(textColor)
                                }

                                Spacer(minLength: 14)

                                VStack {
                                    HStack {
                                        Text(wish.title).lineLimit(1)
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundColor(textColor)

                                        Spacer()
                                        Text(wish.state.description)
                                    }

                                    Spacer(minLength: 5)

                                    Text(wish.description)
                                        .lineLimit(WishKit.config.expandDescriptionInList ? nil : 1)
                                        .foregroundColor(textColor)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(cellBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                            .padding([.leading, .bottom, .trailing], 10)
                            .wkShadow()
                        })
                    }
                }

                Spacer()
            }.background(backgroundColor)

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
