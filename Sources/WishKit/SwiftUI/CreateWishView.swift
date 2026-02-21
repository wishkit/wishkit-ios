//
//  CreateWishView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 8/26/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

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

    let createActionCompletion: () -> Void

    var closeAction: (() -> Void)? = nil

    var saveButtonSize: CGSize {
        #if os(macOS) || os(visionOS)
            return CGSize(width: 100, height: 30)
        #else
            return CGSize(width: 200, height: 45)
        #endif
    }

    var body: some View {
        VStack(spacing: 0) {
            if showCloseButton() {
                HStack {
                    Spacer()
                    CloseButton(closeAction: dismissViewAction)
                        .alert(isPresented: $showConfirmationAlert) {
                            let button = Alert.Button.default(Text(WishKit.config.localization.ok), action: crossPlatformDismiss)
                            
                            return Alert(
                                title: Text(WishKit.config.localization.info),
                                message: Text(WishKit.config.localization.discardEnteredInformation),
                                primaryButton: button,
                                secondaryButton: .cancel()
                            )
                        }
                }
            }

            ScrollView {
                VStack(spacing: 15) {
                    VStack(spacing: 0) {
                        HStack {
                            Text(WishKit.config.localization.title)
                            Spacer()
                            Text("\(viewModel.titleText.count)/50")
                        }
                        .font(.caption2)
                        .padding([.leading, .trailing, .bottom], 5)

                        TextField("", text: $viewModel.titleText)
                            .padding(10)
                            .textFieldStyle(.plain)
                            .foregroundColor(textColor)
                            .background(fieldBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                            .onChange(of: viewModel.titleText) { _ in
                                viewModel.handleTitleAndDescriptionChange()
                            }
                    }

                    VStack(spacing: 0) {
                        HStack {
                            Text(WishKit.config.localization.description)
                            Spacer()
                            Text("\(viewModel.descriptionText.count)/500")
                        }
                        .font(.caption2)
                        .padding([.leading, .trailing, .bottom], 5)

                        TextEditor(text: $viewModel.descriptionText)
                            .padding([.leading, .trailing], 5)
                            .padding([.top, .bottom], 10)
                            .lineSpacing(3)
                            .frame(height: 200)
                            .foregroundColor(textColor)
                            .scrollContentBackgroundCompat(.hidden)
                            .background(fieldBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                            .onChange(of: viewModel.descriptionText) { _ in
                                viewModel.handleTitleAndDescriptionChange()
                            }
                    }

                    if WishKit.config.emailField != .none {
                        VStack(spacing: 0) {
                            HStack {
                                if WishKit.config.emailField == .optional {
                                    Text(WishKit.config.localization.emailOptional)
                                        .font(.caption2)
                                        .padding([.leading, .trailing, .bottom], 5)
                                }

                                if WishKit.config.emailField == .required {
                                    Text(WishKit.config.localization.emailRequired)
                                        .font(.caption2)
                                        .padding([.leading, .trailing, .bottom], 5)
                                }

                                Spacer()
                            }

                            TextField("", text: $viewModel.emailText)
                                .padding(10)
                                .textFieldStyle(.plain)
                                .foregroundColor(textColor)
                                .background(fieldBackgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                        }
                    }

                    #if os(macOS) || os(visionOS)
                    Spacer()
                    #endif

                    WKButton(
                        text: WishKit.config.localization.save,
                        action: submitAction,
                        style: .primary,
                        isLoading: Binding<Bool?>(
                            get: { viewModel.isButtonLoading },
                            set: { viewModel.isButtonLoading = $0 ?? false }
                        ),
                        size: saveButtonSize
                    )
                    .disabled(viewModel.isButtonDisabled)
                    .alert(isPresented: $alertModel.showAlert) {

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
                            let button = Alert.Button.default(Text(WishKit.config.localization.ok))

                            return Alert(
                                title: Text(WishKit.config.localization.info),
                                message: Text(errorText),
                                dismissButton: button
                            )
                        case .emailRequired:
                            let button = Alert.Button.default(Text(WishKit.config.localization.ok))

                            return Alert(
                                title: Text(WishKit.config.localization.info),
                                message: Text(WishKit.config.localization.emailRequiredText),
                                dismissButton: button
                            )
                        case .emailFormatWrong:
                            let button = Alert.Button.default(Text(WishKit.config.localization.ok))

                            return Alert(
                                title: Text(WishKit.config.localization.info),
                                message: Text(WishKit.config.localization.emailFormatWrongText),
                                dismissButton: button
                            )
                        case .none:
                            let button = Alert.Button.default(Text(WishKit.config.localization.ok))
                            return Alert(title: Text(""), dismissButton: button)
                        default:
                            let button = Alert.Button.default(Text(WishKit.config.localization.ok))
                            return Alert(title: Text(""), dismissButton: button)
                        }

                    }
                }
                .frame(maxWidth: 700)
                .padding()

                #if os(iOS)
                Spacer()
                #endif
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .ignoresSafeArea(edges: [.leading, .trailing])
        .toolbarKeyboardDoneButton()
    }

    private func showCloseButton() -> Bool {
        #if os(macOS) || os(visionOS)
            return true
        #else
            return false
        #endif
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
            crossPlatformDismiss()
        }
    }

    private func crossPlatformDismiss() {
        #if os(macOS) || os(visionOS)
        closeAction?()
        #else
        dismissAction()
        #endif
    }

    private func dismissAction() {
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Color Scheme

extension CreateWishView {

    var textColor: Color {
        switch colorScheme {
        case .light:
            WishKit.theme.textColor?.light ?? .black
        case .dark:
            WishKit.theme.textColor?.dark ?? .white
        @unknown default:
            WishKit.theme.textColor?.light ?? .black
        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            WishKit.theme.tertiaryColor?.light ?? PrivateTheme.systemBackgroundColor.light
        case .dark:
            WishKit.theme.tertiaryColor?.dark ?? PrivateTheme.systemBackgroundColor.dark
        @unknown default:
            WishKit.theme.tertiaryColor?.light ?? PrivateTheme.systemBackgroundColor.light
        }
    }

    var fieldBackgroundColor: Color {
        switch colorScheme {
        case .light:
            WishKit.theme.secondaryColor?.light ?? PrivateTheme.elementBackgroundColor.light
        case .dark:
            WishKit.theme.secondaryColor?.dark ?? PrivateTheme.elementBackgroundColor.dark
        @unknown default:
            WishKit.theme.tertiaryColor?.light ?? PrivateTheme.systemBackgroundColor.light
        }
    }
}
