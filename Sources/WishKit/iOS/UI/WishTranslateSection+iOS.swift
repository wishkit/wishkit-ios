//
//  WishTranslateSection+iOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 7/28/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(iOS) && canImport(Translation)
import SwiftUI
import Translation

/// A small "See translation" text button (Instagram-style) that translates a
/// wish's title and description on-device and toggles between translation and original.
@available(iOS 18.0, *)
struct WishTranslateSection: View {

    private let title: String

    private let description: String

    private let shouldOffer: Bool

    @Binding
    private var translatedTitle: String?

    @Binding
    private var translatedDescription: String?

    @Binding
    private var isShowingTranslation: Bool

    @State
    private var translationConfiguration: TranslationSession.Configuration?

    init(
        title: String,
        description: String,
        translatedTitle: Binding<String?>,
        translatedDescription: Binding<String?>,
        isShowingTranslation: Binding<Bool>
    ) {
        self.title = title
        self.description = description
        self._translatedTitle = translatedTitle
        self._translatedDescription = translatedDescription
        self._isShowingTranslation = isShowingTranslation

        switch WishKit.config.translateButton {
        case .hide:
            self.shouldOffer = false
        case .always:
            self.shouldOffer = true
        case .automatic:
            self.shouldOffer = FeedbackLanguage.differsFromAppLanguage("\(title) \(description)")
        }
    }

    var body: some View {
        if shouldOffer {
            Button(action: toggleTranslation) {
                Text(isShowingTranslation ? WishKit.config.localization.seeOriginal : WishKit.config.localization.seeTranslation)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .translationTask(translationConfiguration) { session in
                do {
                    let requests = [
                        TranslationSession.Request(sourceText: title, clientIdentifier: "title"),
                        TranslationSession.Request(sourceText: description, clientIdentifier: "description"),
                    ]

                    for response in try await session.translations(from: requests) {
                        switch response.clientIdentifier {
                        case "title":
                            translatedTitle = response.targetText
                        case "description":
                            translatedDescription = response.targetText
                        default:
                            break
                        }
                    }

                    isShowingTranslation = true
                } catch {
                    printError(self, error.localizedDescription)
                }
            }
        }
    }

    private func toggleTranslation() {
        if isShowingTranslation {
            isShowingTranslation = false
            return
        }

        // Already translated once — just switch back without a new session.
        if translatedTitle != nil || translatedDescription != nil {
            isShowingTranslation = true
            return
        }

        if translationConfiguration == nil {
            translationConfiguration = TranslationSession.Configuration(
                source: nil,
                target: FeedbackLanguage.appLanguage
            )
        } else {
            translationConfiguration?.invalidate()
        }
    }
}
#endif
