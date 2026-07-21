//
//  CreateWishView+macOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/7/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(macOS)
import SwiftUI
import WishKitShared

enum ActiveAlert: Identifiable {
    case success
    case confirmDiscard
    case emailRequired
    case emailFormatWrong
    case createError(String)

    var id: String {
        switch self {
        case .success: return "success"
        case .confirmDiscard: return "confirmDiscard"
        case .emailRequired: return "emailRequired"
        case .emailFormatWrong: return "emailFormatWrong"
        case .createError(let text): return "createError-\(text)"
        }
    }
}

struct CreateWishView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @StateObject
    private var viewModel = CreateWishViewModel()

    @State
    private var activeAlert: ActiveAlert? = nil

    @FocusState
    private var titleFieldFocused: Bool

    let createActionCompletion: () -> Void

    var closeAction: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {

                    // Title
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(WishKit.config.localization.title)
                            Spacer()
                            Text("\(viewModel.titleText.count)/50")
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .textCase(nil)
                        .padding(.horizontal, 15)

                        HStack {
                            TextField("", text: $viewModel.titleText)
                                .textFieldStyle(.plain)
                                .font(.subheadline)
                                .focused($titleFieldFocused)
                                .onChange(of: viewModel.titleText) { _ in
                                    viewModel.handleTitleAndDescriptionChange()
                                }
                        }
                        .padding(.horizontal, 15)
                        .frame(height: 44)
                        .background(fieldBackgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                    }

                    // Description
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(WishKit.config.localization.description)
                            Spacer()
                            Text("\(viewModel.descriptionText.count)/500")
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .textCase(nil)
                        .padding(.horizontal, 15)

                        HStack {
                            TextField("", text: $viewModel.descriptionText, axis: .vertical)
                                .textFieldStyle(.plain)
                                .font(.subheadline)
                                .lineLimit(4...8)
                                .onChange(of: viewModel.descriptionText) { _ in
                                    viewModel.handleTitleAndDescriptionChange()
                                }
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(fieldBackgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                    }

                    // Email (optional)
                    if WishKit.config.emailField != .none {
                        HStack {
                            TextField(emailPlaceholder, text: $viewModel.emailText)
                                .textFieldStyle(.plain)
                                .font(.subheadline)
                                .autocorrectionDisabled()
                        }
                        .padding(.horizontal, 15)
                        .frame(height: 44)
                        .background(fieldBackgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                    }

                }
                .padding()
            }

            // Cancel + Save (pinned to bottom)
            HStack(spacing: 8) {
                Button(action: dismissViewAction) {
                    Text(WishKit.config.localization.cancel)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .keyboardShortcut(.cancelAction)

                Button(action: submitAction) {
                    HStack {
                        if viewModel.isButtonLoading {
                            ProgressView()
                                .controlSize(.small)
                        }
                        Text(WishKit.config.localization.save)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(WishKit.theme.primaryColor)
                .keyboardShortcut(.defaultAction)
                .disabled(viewModel.isButtonDisabled || viewModel.isButtonLoading)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .success:
                return Alert(
                    title: Text(WishKit.config.localization.info),
                    message: Text(WishKit.config.localization.successfullyCreated),
                    dismissButton: .default(Text(WishKit.config.localization.ok)) {
                        createActionCompletion()
                        closeAction?()
                    }
                )
            case .confirmDiscard:
                return Alert(
                    title: Text(WishKit.config.localization.info),
                    message: Text(WishKit.config.localization.discardEnteredInformation),
                    primaryButton: .default(Text(WishKit.config.localization.ok)) { closeAction?() },
                    secondaryButton: .cancel()
                )
            case .emailRequired:
                return Alert(title: Text(WishKit.config.localization.info),
                             message: Text(WishKit.config.localization.emailRequiredText),
                             dismissButton: .default(Text(WishKit.config.localization.ok)))
            case .emailFormatWrong:
                return Alert(title: Text(WishKit.config.localization.info),
                             message: Text(WishKit.config.localization.emailFormatWrongText),
                             dismissButton: .default(Text(WishKit.config.localization.ok)))
            case .createError(let errorText):
                return Alert(title: Text(WishKit.config.localization.info),
                             message: Text(errorText),
                             dismissButton: .default(Text(WishKit.config.localization.ok)))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                titleFieldFocused = true
            }
        }
    }

    private var emailPlaceholder: String {
        WishKit.config.emailField == .required
            ? WishKit.config.localization.emailRequired
            : WishKit.config.localization.emailOptional
    }

    private func submitAction() {
        guard !viewModel.isButtonLoading else { return }
        Task { @MainActor in
            let result = await viewModel.submit()
            switch result {
            case .success:
                activeAlert = .success
            case .emailRequired:
                activeAlert = .emailRequired
            case .emailFormatWrong:
                activeAlert = .emailFormatWrong
            case .createReturnedError(let errorText):
                activeAlert = .createError(errorText)
            }
        }
    }

    private func dismissViewAction() {
        if !viewModel.titleText.isEmpty || !viewModel.descriptionText.isEmpty || !viewModel.emailText.isEmpty {
            activeAlert = .confirmDiscard
        } else {
            closeAction?()
        }
    }
}

extension CreateWishView {

    var backgroundColor: Color {
        WishKit.theme.tertiaryColor?.resolved(for: colorScheme) ?? PrivateTheme.systemBackground
    }

    var fieldBackgroundColor: Color {
        WishKit.theme.secondaryColor?.resolved(for: colorScheme) ?? PrivateTheme.elementBackground
    }
}
#endif
