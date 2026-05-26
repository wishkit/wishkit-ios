import Foundation

struct WishValidation {

    static let titleLimit = 50
    static let descriptionLimit = 500

    static func normalize(
        title: String,
        description: String,
        email: String
    ) -> WishValidationNormalizedInput {
        WishValidationNormalizedInput(
            title: String(title.prefix(titleLimit)),
            description: String(description.prefix(descriptionLimit)),
            email: email
        )
    }

    static func isCreateButtonDisabled(
        title: String,
        description: String
    ) -> Bool {
        title.isEmpty || description.isEmpty
    }

    static func validateEmail(
        email: String,
        fieldRequirement: ConfigurationEmailField
    ) -> WishValidationEmailValidationResult {
        if fieldRequirement == .required && email.isEmpty {
            return .requiredButMissing
        }

        guard !email.isEmpty else {
            return .valid
        }

        let isInvalidEmailFormat = (
            email.count < 6 ||
            !email.contains("@") ||
            !email.contains(".")
        )
        return isInvalidEmailFormat ? .invalidFormat : .valid
    }
}
