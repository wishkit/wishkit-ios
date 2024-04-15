//
//  PrivateFeedbackView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/6/24.
//  Copyright © 2024 Martin Lasek. All rights reserved.
//

import SwiftUI
import Combine
import WishKitShared

/// A private feedback view to gather one time feedback.
/// It allows you to receive feedback privately that is only
/// visible in the dashboard. No votes. No display within the app.
/// Use case: When you don't want to share feedback publicly.
struct PrivateFeedbackView: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @Environment(\.presentationMode)
    var presentationMode

    @StateObject
    private var alertModel = AlertModel()

    @State
    private var emailText = ""

    @State
    private var descriptionText = ""

    @State
    private var isButtonLoading: Bool? = false

    var closeAction: (() -> Void)? = nil

    var saveButtonSize: CGSize {
        #if os(macOS) || os(visionOS)
            return CGSize(width: 100, height: 30)
        #else
            return CGSize(width: 200, height: 45)
        #endif
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Kindly share your feedback")
                    .font(.headline)
                    .padding(.bottom, 5)

                HStack {
                    Text("This feedback is private and is sent directly to the developer.")
                        .font(.callout)
                        .padding(.bottom, 30)

                    Spacer()
                }

                VStack(spacing: 15) {
                    if WishKit.config.emailField != .none {
                        VStack(alignment: .leading, spacing: 0) {
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
                            }

                            TextField("", text: $emailText)
                                .padding(10)
                                .textFieldStyle(.plain)
                                .foregroundColor(textColor)
                                .background(fieldBackgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                        }
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Text(WishKit.config.localization.description)
                            .font(.caption2)
                            .padding([.leading, .trailing, .bottom], 5)

                        TextEditor(text: $descriptionText)
                            .padding([.leading, .trailing], 5)
                            .padding([.top, .bottom], 10)
                            .lineSpacing(3)
                            .frame(height: 200)
                            .foregroundColor(textColor)
                            .scrollContentBackgroundCompat(.hidden)
                            .background(fieldBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: WishKit.config.cornerRadius, style: .continuous))
                            .toolbarKeyboardDoneButton()
                    }
                }

                Spacer(minLength: 30)

                WKButton(text: "Submit", action: {
                    Task {
                        await submitPrivateFeedback()
                    }
                }, isLoading: $isButtonLoading, size: saveButtonSize)
                    .alert(isPresented: $alertModel.showAlert, content: alertView)
            }.padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .ignoresSafeArea(edges: [.leading, .trailing])
        .toolbarKeyboardDoneButton()
    }

    private func submitPrivateFeedback() async {
        if descriptionText.isEmpty {
            alertModel.alertReason = .descriptionRequired
            alertModel.showAlert = true
            return
        }

        if WishKit.config.emailField == .required && emailText.isEmpty {
            alertModel.alertReason = .emailRequired
            alertModel.showAlert = true
            return
        }

        let request = CreatePrivateFeedbackRequest(email: emailText.isEmpty ? nil : emailText, description: descriptionText)

        isButtonLoading = true

        _ = await PrivateFeedbackApi.createPrivateFeedback(createRequest: request)

        isButtonLoading = false

        alertModel.alertReason = .successfullyCreated
        alertModel.showAlert = true
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

    private func alertView() -> Alert {
        switch alertModel.alertReason {
        case .successfullyCreated:
            let button = Alert.Button.default(
                Text(WishKit.config.localization.ok),
                action: {
                    crossPlatformDismiss()
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
        case .descriptionRequired:
            let button = Alert.Button.default(Text(WishKit.config.localization.ok))

            return Alert(
                title: Text(WishKit.config.localization.info),
                message: Text("Description cannot be empty"),
                dismissButton: button
            )
        default:
            let button = Alert.Button.default(Text(WishKit.config.localization.ok))
            return Alert(title: Text(""), dismissButton: button)
        }
    }
}

// MARK: - Color Scheme

extension PrivateFeedbackView {

    var textColor: Color {
        switch colorScheme {
        case .light:

            if let color = WishKit.theme.textColor {
                return color.light
            }

            return .black
        case .dark:
            if let color = WishKit.theme.textColor {
                return color.dark
            }

            return .white
        @unknown default:
            if let color = WishKit.theme.textColor {
                return color.light
            }

            return .black
        }
    }

    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            if let color = WishKit.theme.tertiaryColor {
                return color.light
            }

            return PrivateTheme.systemBackgroundColor.light
        case .dark:
            if let color = WishKit.theme.tertiaryColor {
                return color.dark
            }

            return PrivateTheme.systemBackgroundColor.dark
        @unknown default:
            if let color = WishKit.theme.tertiaryColor {
                return color.light
            }

            return PrivateTheme.systemBackgroundColor.light
        }
    }

    var fieldBackgroundColor: Color {
        switch colorScheme {
        case .light:
            if let color = WishKit.theme.secondaryColor {
                return color.light
            }

            return PrivateTheme.elementBackgroundColor.light
        case .dark:
            if let color = WishKit.theme.secondaryColor {
                return color.dark
            }

            return PrivateTheme.elementBackgroundColor.dark
        @unknown default:
            if let color = WishKit.theme.tertiaryColor {
                return color.light
            }

            return PrivateTheme.systemBackgroundColor.light
        }
    }
}
