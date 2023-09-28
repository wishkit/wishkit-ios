//
//  ScrollView+Compat.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/27/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension ScrollView {
    func refreshableCompat(action: @escaping @Sendable () async -> Void) -> some View {
        if #available(iOS 15, *) {
            return self.refreshable(action: action)
        }

        return self
    }
}
