#if os(iOS)
import SwiftUI
import WishKitShared

struct DetailWishView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @StateObject
    private var viewModel: DetailWishViewModel

    private let wishResponse: WishResponse

    private let voteActionCompletion: () -> Void

    init(
        wishResponse: WishResponse,
        voteActionCompletion: @escaping (() -> Void)
    ) {
        self.wishResponse = wishResponse
        self.voteActionCompletion = voteActionCompletion
        self._viewModel = StateObject(
            wrappedValue: DetailWishViewModel(commentList: wishResponse.commentList)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {

                WishView(wishResponse: wishResponse, viewKind: .detail, voteActionCompletion: voteActionCompletion)
                    .padding()
                    .frame(maxWidth: 700)

                if WishKit.config.commentSection == .show {
                    SeparatorView()
                        .padding([.leading, .trailing])
                        .padding([.top, .bottom], 15)

                    CommentFieldView($viewModel.newCommentValue, isLoading: $viewModel.isLoading) {
                        await viewModel.submitComment(for: wishResponse.id)
                    }
                    .padding([.leading, .trailing])
                    .frame(maxWidth: 700)

                    CommentListView(commentList: $viewModel.commentList)
                        .frame(maxWidth: 700, maxHeight: .infinity)
                } else {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if WishKit.config.commentSection == .hide {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
}

// MARK: - Color Scheme

extension DetailWishView {

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            WishKit.theme.tertiaryColor?.light ?? PrivateTheme.systemBackgroundColor.light
        case .dark:
            WishKit.theme.tertiaryColor?.dark ?? PrivateTheme.systemBackgroundColor.dark
        @unknown default:
            PrivateTheme.systemBackgroundColor.light
        }
    }
}
#endif
