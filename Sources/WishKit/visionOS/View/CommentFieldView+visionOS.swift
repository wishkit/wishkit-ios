//
//  CommentFieldView+visionOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/11/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(visionOS)
import SwiftUI
import WishKitShared

struct CommentFieldView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @Binding
    private var textFieldValue: String

    @Binding
    private var isLoading: Bool

    @State
    private var submitTask: Task<Void, Never>?

    private let submitAction: () async throws -> ()

    init(
        _ textFieldValue: Binding<String>,
        isLoading: Binding<Bool>,
        submitAction: @escaping () async throws -> ()
    ) {
        self._textFieldValue = textFieldValue
        self._isLoading = isLoading
        self.submitAction = submitAction
    }

    var body: some View {
        HStack(spacing: 8) {
            TextField(WishKit.config.localization.writeAComment, text: $textFieldValue)
                .textFieldStyle(.plain)
                .font(.footnote)
                .foregroundColor(textColor)

            if isLoading {
                ProgressView()
                    .controlSize(.small)
            } else {
                Button(action: startSubmitTask) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(WishKit.theme.primaryColor)
                }
                .buttonStyle(.plain)
                .disabled(textFieldValue.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 44)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
        .onDisappear {
            submitTask?.cancel()
            submitTask = nil
        }
    }

    private func startSubmitTask() {
        submitTask?.cancel()
        submitTask = Task { @MainActor in
            defer { submitTask = nil }
            do {
                try await submitAction()
            } catch {
                print("❌ \(error.localizedDescription)")
            }
        }
    }
}

extension CommentFieldView {

    var textColor: Color {
        WishKit.theme.textColor?.resolved(for: colorScheme) ?? .primary
    }
}
#endif
