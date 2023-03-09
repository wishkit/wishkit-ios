//
//  CreateWishVC.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import WishKitShared

final class CreateWishVC: UIViewController {

    weak var delegate: CreateWishDelegate?

    private var safeArea: UILayoutGuide!

    private let viewModel = CreateWishVM()

    private let scrollView = UIScrollView()

    private let wishTitleSectionLabel = UILabel("Title")

    private let wishTitleCharacterCountLabel = UILabel()

    private let wishTitleTF = TextField(padding: UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10))

    private let wishDescriptionSectionLabel = UILabel("Description")

    private let wishDescriptionCharacterCountLabel = UILabel()

    private let wishDescriptionTV = TextView()

    private let saveButton = UIButton(type: .system)

    private let toolbar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wishTitleTF.becomeFirstResponder()
    }
}

// MARK: - Logic

extension CreateWishVC {

    private func updateSaveButton() {
        let backgroundColor = WishKit.theme.primaryColor
        saveButton.backgroundColor = viewModel.canSave() ? backgroundColor : backgroundColor.withAlphaComponent(0.66)
        saveButton.isEnabled = viewModel.canSave()
    }

    private func updateCharacterCountLabels() {
        wishDescriptionCharacterCountLabel.text = "\(viewModel.characterCount(of: .description))/\(viewModel.characterLimit(of: .description))"
        wishTitleCharacterCountLabel.text = "\(viewModel.characterCount(of: .title))/\(viewModel.characterLimit(of: .title))"
    }

    private func sendCreateRequest(_ createRequest: CreateWishRequest) {
        WishApi.createWish(createRequest: createRequest) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.handleCreateSuccess(response: response)
                case .failure(let error):
                    self.handleApiError(error: error)
                }
            }
        }
    }

    private func handleCreateSuccess(response: CreateWishResponse) {
        AlertManager.showMessage(on: self, message: "Successfully created!") {
            if let delegate = self.delegate {
                delegate.newWishWasSuccessfullyCreated()
            } else {
                printError(self, "Missing delegate.")
            }

            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }
    }

    private func handleApiError(error: ApiError.Kind) {
        AlertManager.showMessage(on: self, message: error.description) {
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }
    }
}

// MARK: - Setup

extension CreateWishVC {
    private func setupView() {
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = .secondarySystemBackground

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        setupKeyboardManager()
        setupKeyboardToolbar()

        setupScrollView()

        setupWishTitleSectionLabel()
        setupWishTitleCharacterCountLabel()
        setupWishTitleTV()

        setupWishDescriptionSectionLabel()
        setupWishDescriptionCharacterCountLabel()
        setupWishDescriptionTV()

        setupSaveButton()
    }

    private func setupKeyboardToolbar() {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexSpace, done]
        toolbar.sizeToFit()

        wishTitleTF.inputAccessoryView = toolbar
        wishDescriptionTV.inputAccessoryView = toolbar
    }

    private func setupScrollView() {
        view.addSubview(scrollView)

        scrollView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: safeArea.bottomAnchor,
            trailing: view.trailingAnchor
        )

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
    }

    private func setupWishTitleSectionLabel() {
        scrollView.addSubview(wishTitleSectionLabel)

        wishTitleSectionLabel.anchor(
            top: scrollView.topAnchor,
            leading: safeArea.leadingAnchor,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 15, left: 7, bottom: 0, right: 0)
        )

        wishTitleSectionLabel.font = .boldSystemFont(ofSize: 10)
    }

    private func setupWishTitleCharacterCountLabel() {
        scrollView.addSubview(wishTitleCharacterCountLabel)

        wishTitleCharacterCountLabel.anchor(
            top: wishTitleSectionLabel.topAnchor,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        )

        wishTitleCharacterCountLabel.font = .boldSystemFont(ofSize: 10)
        wishTitleCharacterCountLabel.textAlignment = .right

        updateCharacterCountLabels()
    }

    private func setupWishTitleTV() {
        scrollView.addSubview(wishTitleTF)

        wishTitleTF.anchor(
            top: wishTitleSectionLabel.bottomAnchor,
            leading: safeArea.leadingAnchor,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        )

        wishTitleTF.addTarget(viewModel, action: #selector(viewModel.titleHasChangedAction), for: .editingChanged)
    }

    private func setupWishDescriptionSectionLabel() {
        scrollView.addSubview(wishDescriptionSectionLabel)

        wishDescriptionSectionLabel.anchor(
            top: wishTitleTF.bottomAnchor,
            leading: safeArea.leadingAnchor,
            padding: UIEdgeInsets(top: 15, left: 7, bottom: 0, right: 0)
        )

        wishDescriptionSectionLabel.font = .boldSystemFont(ofSize: 10)
    }

    private func setupWishDescriptionCharacterCountLabel() {
        scrollView.addSubview(wishDescriptionCharacterCountLabel)

        wishDescriptionCharacterCountLabel.anchor(
            top: wishDescriptionSectionLabel.topAnchor,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        )

        wishDescriptionCharacterCountLabel.font = .boldSystemFont(ofSize: 10)
        wishDescriptionCharacterCountLabel.textAlignment = .right

        updateCharacterCountLabels()
    }

    private func setupWishDescriptionTV() {
        scrollView.addSubview(wishDescriptionTV)

        wishDescriptionTV.anchor(
            top: wishDescriptionSectionLabel.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0),
            size: CGSize(width: 0, height: 260)
        )

        wishDescriptionTV.delegate = viewModel
        wishDescriptionTV.font = .systemFont(ofSize: UIFont.labelFontSize)
    }

    private func setupSaveButton() {
        scrollView.addSubview(saveButton)

        saveButton.anchor(
            top: wishDescriptionTV.bottomAnchor,
            centerX: wishDescriptionTV.centerXAnchor,
            padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0),
            size: CGSize(width: 200, height: 45)
        )

        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setTitleColor(.systemGray6, for: .disabled)

        saveButton.layer.cornerRadius = 12
        saveButton.layer.cornerCurve = .continuous
        saveButton.addTarget(self, action: #selector(saveWishAction), for: .touchUpInside)

        updateSaveButton()
    }

    private func setupKeyboardManager() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: - Actions

extension CreateWishVC {

    @objc func adjustForKeyboard(notification: Notification) {
        guard
            let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - 35,
                right: 0
            )
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveWishAction() {
        dismissKeyboard()

        let request = viewModel.makeRequest()

        switch request {
        case .create(let createRequest):
            sendCreateRequest(createRequest)
        }
    }
}

// MARK: - CreateWishVMDelegate

extension CreateWishVC: CreateWishVMDelegate {
    func stateHasChanged() {
        updateCharacterCountLabels()
        updateSaveButton()
    }
}
#endif
