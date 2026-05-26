//
//  SwiftUIView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/14/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

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
        ZStack {
            TextField(WishKit.config.localization.writeAComment, text: $textFieldValue)
                .textFieldStyle(.plain)
                .font(.footnote)
                .padding([.top, .leading, .bottom], 15)
                .padding([.trailing], 40)
                .foregroundColor(textColor)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))

            HStack {
                Spacer()
                if isLoading {
                    ProgressView()
                        .controlSizeCompat(.small)
                        .padding(10)
                } else {
                    Button(action: startSubmitTask) {
                        Image(systemName: "paperplane.fill")
                            .padding(10)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(WishKit.theme.primaryColor)
                    .disabled(textFieldValue.replacingOccurrences(of: " ", with: "").isEmpty)
                }
            }
        }
        .onDisappear {
            submitTask?.cancel()
            submitTask = nil
        }
        .toolbarKeyboardDoneButton()
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
        switch colorScheme {
        case .light:
            WishKit.theme.textColor?.light ?? .black
        case .dark:
            WishKit.theme.textColor?.dark ?? .white
        @unknown default:
            .black
        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            WishKit.theme.secondaryColor?.light ?? PrivateTheme.elementBackgroundColor.light
        case .dark:
            WishKit.theme.secondaryColor?.dark ?? PrivateTheme.elementBackgroundColor.dark
        @unknown default:
            PrivateTheme.elementBackgroundColor.dark
        }
    }
}
