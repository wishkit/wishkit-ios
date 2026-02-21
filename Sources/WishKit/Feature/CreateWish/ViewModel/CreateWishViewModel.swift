import Foundation
import Combine
import WishKitShared

@MainActor
final class CreateWishViewModel: ObservableObject {

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
        let normalized = WishValidation.normalize(
            title: titleText,
            description: descriptionText,
            email: emailText
        )
        titleText = normalized.title
        descriptionText = normalized.description
        isButtonDisabled = WishValidation.isCreateButtonDisabled(
            title: titleText,
            description: descriptionText
        )
    }

    func submit() async -> CreateWishSubmitOutcome {
        switch WishValidation.validateEmail(
            email: emailText,
            fieldRequirement: WishKit.config.emailField
        ) {
        case .requiredButMissing:
            return .emailRequired
        case .invalidFormat:
            return .emailFormatWrong
        case .valid:
            break
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
