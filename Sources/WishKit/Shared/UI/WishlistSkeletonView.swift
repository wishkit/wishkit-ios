//
//  WishlistSkeletonView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/7/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import SwiftUI

struct WishlistSkeletonView: View {

    private var buttonCornerRadius: CGFloat {
        if #available(iOS 26.0, visionOS 26.0, macOS 26.0, *) {
            return 12
        } else {
            return 8
        }
    }
    
    var body: some View {
        List(0..<6, id: \.self) { _ in
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: buttonCornerRadius, style: .continuous)
                    .fill(skeletonFill)
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Placeholder title")
                        .font(.system(size: 17, weight: .semibold))
                    Text("A placeholder description.")
                        .font(.system(size: 13))
                }

                Spacer()
            }
            .padding(.vertical, 4)
            .fullWidthListSeparator()
        }
        .redacted(reason: .placeholder)
        .disabled(true)
    }

    private var skeletonFill: Color {
        #if os(macOS)
        Color.gray.opacity(0.25)
        #else
        Color(uiColor: .tertiarySystemFill)
        #endif
    }
}
