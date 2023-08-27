//
//  CreateWishVM.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/11/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import WishKitShared

final class CreateWishVM: NSObject {

    var state = State.create(.initial)

    weak var delegate: CreateWishVMDelegate?

    private var wishTitle = ""

    private var email: String? = nil

    private var wishDescription = ""

    private let titleCharLimit = 50

    private let descriptionCharLimit = 500

    // MARK: - Public

    func canSave() -> Bool {
        let fieldsAreBothNotEmpty = !wishTitle.isEmpty && !wishDescription.isEmpty
        let withinCharacterLimits = wishTitle.count <= titleCharLimit && wishDescription.count <= descriptionCharLimit

        switch state {
        case .create(let change):
            return change == .hasChanged && withinCharacterLimits && fieldsAreBothNotEmpty
        }
    }

    func showDiscardWarning() -> Bool {
        return !wishTitle.isEmpty || !wishDescription.isEmpty
    }

    func characterCount(of property: Property) -> Int {
        switch property {
        case .title:
            return wishTitle.count
        case .description:
            return wishDescription.count
        }
    }

    func characterLimit(of property: Property) -> Int {
        switch property {
        case .title:
            return titleCharLimit
        case .description:
            return descriptionCharLimit
        }
    }

    func makeRequest() -> Request<CreateWishRequest> {
        switch state {
        case .create:
            return .create(makeCreateRequest())
        }
    }

    // MARK: - Private

    private func updateState() {
        switch state {
        case .create:
            state = .create(.hasChanged)
        }

        guard let delegate = delegate else {
            printError(self, "Delegate is missing.")
            return
        }

        delegate.stateHasChanged()
    }

    private func makeCreateRequest() -> CreateWishRequest {
        return CreateWishRequest(
            title: wishTitle,
            description: wishDescription,
            email: email
        )
    }

    func descriptionHasChangedAction(_ textView: UITextView) {
        if let text = textView.text, text.count > descriptionCharLimit {
            let _ = textView.text?.popLast()
        }

        wishDescription = textView.text ?? ""
        updateState()
    }

    // MARK: - Actions

    @objc func titleHasChangedAction(_ textField: UITextField) {
        if let text = textField.text, text.count > titleCharLimit {
            let _ = textField.text?.popLast()
        }

        wishTitle = textField.text ?? ""
        updateState()
    }

    @objc func emailHasChangedAction(_ textField: UITextField) {
        if let text = textField.text, text.count > titleCharLimit {
            let _ = textField.text?.popLast()
        }

        email = textField.text ?? ""
        updateState()
    }
}

extension CreateWishVM {
    enum Property {
        case title
        case description
    }

    enum State {
        case create(Change)
    }

    enum Change {
        case initial
        case hasChanged
    }

    indirect enum Request<Create> {
        case create(Create)
    }
}

extension CreateWishVM: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        descriptionHasChangedAction(textView)
    }
}
#endif
