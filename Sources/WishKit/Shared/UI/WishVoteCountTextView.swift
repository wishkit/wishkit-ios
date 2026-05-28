//
//  WishVoteCountTextView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import SwiftUI

struct WishVoteCountTextView: View {

    let voteCount: Int

    let voteCountScale: CGFloat

    var body: some View {
        let base = Text(String(describing: voteCount))
            .font(.footnote.weight(.semibold))
            .frame(minWidth: 35)
            .scaleEffect(voteCountScale)

        if #available(iOS 17.0, macOS 14.0, *) {
            base.contentTransition(.numericText(value: Double(voteCount)))
        } else {
            base
        }
    }
}
