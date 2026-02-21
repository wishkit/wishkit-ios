enum AlertReason {

    case alreadyVoted

    case alreadyImplemented

    case voteReturnedError(String)

    case successfullyCreated

    case createReturnedError(String)

    case emailRequired

    case emailFormatWrong

    case none
}
