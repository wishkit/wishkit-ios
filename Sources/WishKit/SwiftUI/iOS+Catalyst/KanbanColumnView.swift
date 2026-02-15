//
//  KanbanColumnView.swift
//  wishkit-ios
//

#if os(iOS)
import SwiftUI
import WishKitShared

struct KanbanColumn: Identifiable {
    let id: String
    let state: LocalWishState

    init(state: LocalWishState) {
        self.state = state
        self.id = state.description
    }
}

struct KanbanColumnView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    let state: LocalWishState
    let wishes: [WishResponse]
    let onVoteAction: () -> Void

    private var columnColor: Color {
        state.badgeColor(for: colorScheme)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            columnHeader
            Divider().padding(.horizontal, 8)
            columnContent
        }
        .containerRelativeFrame(.horizontal) { length, _ in
            length > 500 ? 350 : length * 0.85
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(WishlistColors.cellBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 16))
        .padding(.bottom, 20)
    }

    // MARK: - Header

    private var columnHeader: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 3)
                .fill(columnColor)
                .frame(width: 6, height: 20)

            Text(state.description)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)

            Text("\(wishes.count)")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(columnColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(columnColor.opacity(0.15))
                )

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    // MARK: - Content

    private var columnContent: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 8) {
                ForEach(wishes) { wish in
                    NavigationLink {
                        DetailWishView(
                            wishResponse: wish,
                            voteActionCompletion: onVoteAction
                        )
                    } label: {
                        WishView(
                            wishResponse: wish,
                            viewKind: .list,
                            voteActionCompletion: onVoteAction
                        )
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .contentShape(Rectangle())
        .clipped()
    }
}
#endif
