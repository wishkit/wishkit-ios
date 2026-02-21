import Foundation
import Combine
import WishKitShared

@MainActor
final class CreateWishViewModel: ObservableObject {

    enum SubmitOutcome: Equatable {
        case success
        case emailRequired
        case emailFormatWrong
        case createReturnedError(String)
    }

    @Published
    var titleText = ""

    @Published
    var emailText = ""

    @Published
    var descriptionText = ""

    @Published
    var isButtonDisabled = true

    @Published
    var isButtonLoading = false

    private let createWishAction: (CreateWishRequest) async -> ApiResult<CreateWishResponse, ApiError>

    init(
        createWishAction: @escaping (CreateWishRequest) async -> ApiResult<CreateWishResponse, ApiError> = CreateWishViewModel.defaultCreateWishAction
    ) {
        self.createWishAction = createWishAction
    }

    func handleTitleAndDescriptionChange() {
        let titleLimit = 50
        let descriptionLimit = 500

        if titleText.count > titleLimit {
            titleText = String(titleText.prefix(titleLimit))
        }

        if descriptionText.count > descriptionLimit {
            descriptionText = String(descriptionText.prefix(descriptionLimit))
        }

        isButtonDisabled = titleText.isEmpty || descriptionText.isEmpty
    }

    func submit() async -> SubmitOutcome {
        if WishKit.config.emailField == .required && emailText.isEmpty {
            return .emailRequired
        }

        let isInvalidEmailFormat = (
            emailText.count < 6 ||
            !emailText.contains("@") ||
            !emailText.contains(".")
        )
        if !emailText.isEmpty && isInvalidEmailFormat {
            return .emailFormatWrong
        }

        isButtonLoading = true
        defer { isButtonLoading = false }

        let createRequest = CreateWishRequest(
            title: titleText,
            description: descriptionText,
            email: emailText
        )
        let result = await createWishAction(createRequest)
        switch result {
        case .success:
            return .success
        case .failure(let error):
            return .createReturnedError(error.reason.description)
        }
    }

    private static func defaultCreateWishAction(
        createRequest: CreateWishRequest
    ) async -> ApiResult<CreateWishResponse, ApiError> {
        await WishApi.createWish(createRequest: createRequest)
    }
}
