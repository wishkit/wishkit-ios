//
//  KanbanBoardView.swift
//  wishkit-ios
//

#if os(iOS)
import SwiftUI
import WishKitShared

struct KanbanBoardView: View {

    @ObservedObject var wishModel: WishModel

    private var columns: [KanbanColumn] {
        let allColumns: [KanbanColumn] = [
            KanbanColumn(state: .library(.inProgress)),
            KanbanColumn(state: .library(.planned)),
            KanbanColumn(state: .library(.inReview)),
            KanbanColumn(state: .library(.pending)),
            KanbanColumn(state: .library(.completed)),
        ]
        return allColumns.filter { !wishesFor($0.state).isEmpty }
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(columns) { column in
                        KanbanColumnView(
                            state: column.state,
                            wishes: wishesFor(column.state),
                            onVoteAction: { wishModel.fetchList() }
                        )
                        .id(column.id)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .onAppear {
                if let first = columns.first {
                    proxy.scrollTo(first.id, anchor: .leading)
                }
            }
        }
    }

    // MARK: - Data

    private func wishesFor(_ state: LocalWishState) -> [WishResponse] {
        switch state {
        case .all:
            return wishModel.all
        case .library(let wishState):
            switch wishState {
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
}
#endif
