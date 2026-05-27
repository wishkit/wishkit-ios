//
//  CreateWishView+iOS.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 5/26/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

#if os(iOS)
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

    let createActionCompletion: () -> Void

    var body: some View {
        Form {
            Section {
                TextField(WishKit.config.localization.title, text: $viewModel.titleText)
                    .onChange(of: viewModel.titleText) { _ in
                        viewModel.handleTitleAndDescriptionChange()
                    }
            } footer: {
                HStack {
                    Spacer()
                    Text("\(viewModel.titleText.count)/50")
                }
            }

            Section {
                TextField(
                    WishKit.config.localization.description,
                    text: $viewModel.descriptionText,
                    axis: .vertical
                )
                .lineLimit(5...10)
                .onChange(of: viewModel.descriptionText) { _ in
                    viewModel.handleTitleAndDescriptionChange()
                }
            } footer: {
                HStack {
                    Spacer()
                    Text("\(viewModel.descriptionText.count)/500")
                }
            }

            if WishKit.config.emailField != .none {
                Section {
                    TextField(emailPlaceholder, text: $viewModel.emailText)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .textContentType(.emailAddress)
                        .autocorrectionDisabled()
                }
            }

            Section {
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
                .disabled(viewModel.isButtonDisabled || viewModel.isButtonLoading)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .scrollContentBackground(.hidden)
        .background(backgroundColor)
        .alert(isPresented: $alertModel.showAlert, content: makeAlert)
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
        switch colorScheme {
        case .light:
            WishKit.theme.tertiaryColor?.light ?? PrivateTheme.systemBackgroundColor.light
        case .dark:
            WishKit.theme.tertiaryColor?.dark ?? PrivateTheme.systemBackgroundColor.dark
        @unknown default:
            WishKit.theme.tertiaryColor?.light ?? PrivateTheme.systemBackgroundColor.light
        }
    }
}
#endif
