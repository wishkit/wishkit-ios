//
//  WishlistSkeletonView+iOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 5/28/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(iOS)
import SwiftUI

struct WishlistSkeletonView: View {
    var body: some View {
        List(0..<6, id: \.self) { _ in
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(uiColor: .tertiarySystemFill))
                    .frame(width: 44, height: 44)

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
}
#endif
