//
//  String+Extensions.swift
//  wishkit-ios
//
//  Created by Abdullah Alhaider on 19/02/2025.
//

import Foundation

extension String {
    /// Localize the string using the current bundle
    ///
    /// - Discussion:
    /// This method is used to localize the string using the current bundle.
    /// If for any reason the `Bundle.module` is not available, it's because the
    /// `Resources` folder is not included in the same level as the source files.
    /// - Returns: Localized string
    func localized(bundle: Bundle = Bundle.module) -> String {
        let localizedString = NSLocalizedString(self, bundle: bundle, comment: "")
        return localizedString
    }
}
