//
//  SegmentedView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/15/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI
import WishKitShared

extension WishState: Identifiable {
    public var id: Self { self }

    public var description: String {
        switch self {
        case .approved:
            WishKit.config.localization.approved
        case .implemented:
            WishKit.config.localization.implemented
        case .pending:
            WishKit.config.localization.pending
        case .inReview:
            WishKit.config.localization.inReview
        case .planned:
            WishKit.config.localization.planned
        case .inProgress:
            WishKit.config.localization.inProgress
        case .completed:
            WishKit.config.localization.completed
        default:
            "Not Supported"
        }
    }
}
