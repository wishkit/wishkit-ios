import Foundation
import Combine
import SwiftUI
import WishKitShared

@MainActor
final class DetailWishViewModel: ObservableObject {

    @Published
    var newCommentValue = ""

    @Published
    var isLoading = false

    @Published
    var commentList: [CommentResponse]

    private let createCommentAction: (CreateCommentRequest) async -> ApiResult<CommentResponse, ApiError>

    init(
        commentList: [CommentResponse],
        createCommentAction: @escaping (CreateCommentRequest) async -> ApiResult<CommentResponse, ApiError> = DetailWishViewModel.defaultCreateCommentAction
    ) {
        self.commentList = commentList
        self.createCommentAction = createCommentAction
    }

    func submitComment(for wishId: UUID) async {
        let trimmedComment = newCommentValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedComment.isEmpty else {
            return
        }

        let request = CreateCommentRequest(
            wishId: wishId,
            description: trimmedComment
        )

        isLoading = true
        let response = await createCommentAction(request)
        isLoading = false

        switch response {
        case .success(let commentResponse):
            withAnimation {
                commentList.insert(commentResponse, at: 0)
            }
            newCommentValue = ""
        case .failure(let error):
            print("❌ \(error.localizedDescription)")
        }
    }

    private static func defaultCreateCommentAction(
        request: CreateCommentRequest
    ) async -> ApiResult<CommentResponse, ApiError> {
        await CommentApi.createComment(request: request)
    }
}
