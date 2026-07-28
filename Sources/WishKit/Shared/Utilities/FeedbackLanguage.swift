//
//  FeedbackLanguage.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 7/28/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation
import NaturalLanguage

/// Detects — fully on-device — whether a piece of user-generated feedback is
/// written in a different language than the one the app is running in.
enum FeedbackLanguage {

    /// Below this length detection is too unreliable ("Dark Mode"), so we treat it as a match.
    private static let minimumTextLength = 10

    private static let minimumConfidence = 0.6

    static var appLanguage: Locale.Language {
        Locale.Language(identifier: Bundle.main.preferredLocalizations.first ?? "en")
    }

    static func differsFromAppLanguage(_ text: String) -> Bool {
        guard let detected = dominantLanguage(of: text) else {
            return false
        }

        return matches(detected, appLanguage) == false
    }

    static func dominantLanguage(of text: String) -> Locale.Language? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= minimumTextLength else {
            return nil
        }

        let recognizer = NLLanguageRecognizer()
        recognizer.processString(trimmed)

        guard let language = recognizer.dominantLanguage else {
            return nil
        }

        let confidence = recognizer.languageHypotheses(withMaximum: 1)[language] ?? 0
        guard confidence >= minimumConfidence else {
            return nil
        }

        return Locale.Language(identifier: language.rawValue)
    }

    /// Languages match when their language codes match; scripts only break a
    /// match when both are known (zh-Hans vs zh-Hant).
    static func matches(_ lhs: Locale.Language, _ rhs: Locale.Language) -> Bool {
        guard lhs.languageCode == rhs.languageCode else {
            return false
        }

        if let lhsScript = lhs.script, let rhsScript = rhs.script, lhsScript != rhsScript {
            return false
        }

        return true
    }
}
