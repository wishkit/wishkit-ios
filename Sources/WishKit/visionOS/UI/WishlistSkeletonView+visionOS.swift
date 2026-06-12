//
//  WishlistSkeletonView+visionOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/11/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(visionOS)
import SwiftUI

struct WishlistSkeletonView: View {

    private var buttonCornerRadius: CGFloat {
        if #available(visionOS 26.0, *) {
            return 12
        } else {
            return 8
        }
    }

    var body: some View {
        List(0..<6, id: \.self) { _ in
            Button(action: {}) {
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: buttonCornerRadius, style: .continuous)
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 14)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Placeholder title")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("A placeholder description.")
                            .font(.callout)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.bordered)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
        .listRowSpacing(15)
        .scrollContentBackground(.hidden)
        .redacted(reason: .placeholder)
        .disabled(true)
    }
}
#endif
