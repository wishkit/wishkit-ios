//
//  CreateWishView+visionOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 6/7/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(visionOS)
import SwiftUI
import WishKitShared

struct CreateWishView: View {

    @Environment(\.presentationMode)
    var presentationMode

    @Environment(\.colorScheme)
    private var colorScheme

    @ObservedObject
    private var alertModel = AlertModel()

    @StateObject
    private var viewModel = CreateWishViewModel()

    @State
    private var showConfirmationAlert = false

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
                        .background(.thinMaterial)
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
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                    }

                    // Email (optional)
                    if WishKit.config.emailField != .none {
                        HStack {
                            TextField(emailPlaceholder, text: $viewModel.emailText)
                                .textFieldStyle(.plain)
                                .font(.subheadline)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .textContentType(.emailAddress)
                                .autocorrectionDisabled()
                        }
                        .padding(.horizontal, 15)
                        .frame(height: 44)
                        .background(.thinMaterial)
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
        .alert(isPresented: $alertModel.showAlert, content: makeAlert)
        .alert(isPresented: $showConfirmationAlert) {
            let button = Alert.Button.default(Text(WishKit.config.localization.ok), action: { closeAction?() })

            return Alert(
                title: Text(WishKit.config.localization.info),
                message: Text(WishKit.config.localization.discardEnteredInformation),
                primaryButton: button,
                secondaryButton: .cancel()
            )
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
        Task { @MainActor in
            let result = await viewModel.submit()
            switch result {
            case .success:
                alertModel.alertReason = .successfullyCreated
            case .emailRequired:
                alertModel.alertReason = .emailRequired
            case .emailFormatWrong:
                alertModel.alertReason = .emailFormatWrong
            case .createReturnedError(let errorText):
                alertModel.alertReason = .createReturnedError(errorText)
            }
            alertModel.showAlert = true
        }
    }

    private func dismissViewAction() {
        if !viewModel.titleText.isEmpty || !viewModel.descriptionText.isEmpty || !viewModel.emailText.isEmpty {
            showConfirmationAlert = true
        } else {
            closeAction?()
        }
    }

    private func dismissAction() {
        presentationMode.wrappedValue.dismiss()
    }

    private func makeAlert() -> Alert {
        switch alertModel.alertReason {
        case .successfullyCreated:
            let button = Alert.Button.default(
                Text(WishKit.config.localization.ok),
                action: {
                    createActionCompletion()
                    dismissAction()
                }
            )
            return Alert(
                title: Text(WishKit.config.localization.info),
                message: Text(WishKit.config.localization.successfullyCreated),
                dismissButton: button
            )
        case .createReturnedError(let errorText):
            return Alert(
                title: Text(WishKit.config.localization.info),
                message: Text(errorText),
                dismissButton: .default(Text(WishKit.config.localization.ok))
            )
        case .emailRequired:
            return Alert(
                title: Text(WishKit.config.localization.info),
                message: Text(WishKit.config.localization.emailRequiredText),
                dismissButton: .default(Text(WishKit.config.localization.ok))
            )
        case .emailFormatWrong:
            return Alert(
                title: Text(WishKit.config.localization.info),
                message: Text(WishKit.config.localization.emailFormatWrongText),
                dismissButton: .default(Text(WishKit.config.localization.ok))
            )
        case .none:
            return Alert(
                title: Text(""),
                dismissButton: .default(Text(WishKit.config.localization.ok))
            )
        default:
            return Alert(
                title: Text(""),
                dismissButton: .default(Text(WishKit.config.localization.ok))
            )
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
