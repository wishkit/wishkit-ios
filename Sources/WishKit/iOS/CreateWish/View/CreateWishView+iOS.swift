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
                TextField("", text: $viewModel.titleText)
                    .onChange(of: viewModel.titleText) { _ in
                        viewModel.handleTitleAndDescriptionChange()
                    }
                    .font(.subheadline)
            } header: {
                HStack {
                    Text(WishKit.config.localization.title)
                    Spacer()
                    Text("\(viewModel.titleText.count)/50")
                }
                .font(.caption2)
                .textCase(nil)
            }

            Section {
                TextField("", text: $viewModel.descriptionText, axis: .vertical)
                    .font(.subheadline)
                    .lineLimit(4...8)
                    .onChange(of: viewModel.descriptionText) { _ in
                        viewModel.handleTitleAndDescriptionChange()
                    }
            } header: {
                HStack {
                    Text(WishKit.config.localization.description)
                    Spacer()
                    Text("\(viewModel.descriptionText.count)/500")
                }
                .font(.caption2)
                .textCase(nil)
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
        .navigationTitle(WishKit.config.localization.createWish)
        .navigationBarTitleDisplayMode(.inline)
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
        WishKit.theme.tertiaryColor?.resolved(for: colorScheme) ?? PrivateTheme.systemBackground
    }
}
#endif
