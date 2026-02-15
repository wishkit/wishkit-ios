//
//  RoadmapOnboardingView.swift
//  wishkit-ios
//

#if os(iOS)
import SwiftUI

struct RoadmapOnboardingView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "map.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.accentColor.gradient)

            VStack(spacing: 12) {
                Text("roadmapOnboardingTitle".localized())
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)

                Text("roadmapOnboardingBody".localized())
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)

            Spacer()

            Button(action: onContinue) {
                Text("roadmapOnboardingButton".localized())
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.accentColor)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(WishlistColors.background(for: colorScheme))
    }
}
#endif
