enum CreateWishSubmitOutcome: Equatable {

    case success

    case emailRequired

    case emailFormatWrong

    case createReturnedError(String)
}
