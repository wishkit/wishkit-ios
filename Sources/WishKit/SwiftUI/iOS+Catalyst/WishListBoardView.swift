//
//  WishListBoardView.swift
//  wishkit-ios
//

#if os(iOS)
import SwiftUI
import WishKitShared

struct WishListBoardView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @ObservedObject var wishModel: WishModel

    /// Ordered sections: active states first, completed last.
    private var sections: [WishListSection] {
        let definitions: [(LocalWishState, [WishResponse])] = [
            (.library(.inProgress), wishModel.inProgressList),
            (.library(.planned),    wishModel.plannedList),
            (.library(.inReview),   wishModel.inReviewList),
            (.library(.pending),    wishModel.pendingList),
            (.library(.completed),  wishModel.completedList),
        ]
        return definitions
            .filter { !$0.1.isEmpty }
            .map { WishListSection(state: $0.0, wishes: $0.1) }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(sections) { section in
                    SectionHeaderView(
                        state: section.state,
                        count: section.wishes.count
                    )

                    ForEach(section.wishes) { wish in
                        NavigationLink {
                            DetailWishView(
                                wishResponse: wish,
                                voteActionCompletion: { wishModel.fetchList() }
                            )
                        } label: {
                            WishView(
                                wishResponse: wish,
                                viewKind: .list,
                                voteActionCompletion: { wishModel.fetchList() }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Section Model

private struct WishListSection: Identifiable {
    let state: LocalWishState
    let wishes: [WishResponse]
    var id: String { state.id }
}

// MARK: - Section Header

private struct SectionHeaderView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    let state: LocalWishState
    let count: Int

    private var sectionColor: Color {
        state.badgeColor(for: colorScheme)
    }

    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 3)
                .fill(sectionColor)
                .frame(width: 5, height: 18)

            Text(state.description)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)

            Text("\(count)")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(sectionColor)
                .padding(.horizontal, 7)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(sectionColor.opacity(0.15))
                )

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
#endif
