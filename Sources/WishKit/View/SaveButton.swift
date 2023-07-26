//
//  SaveButton.swift
//  
//
//  Created by Martin Lasek on 7/26/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//
#if canImport(UIKit)
import UIKit

final class SaveButton: UIButton {

    private let spinner = UIActivityIndicatorView(style: .medium)

    private let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(state: ButtonState) {
        switch state {
        case .active:
            isEnabled = true
            layer.opacity = 1
            setTitle(title, for: .normal)
            spinner.stopAnimating()
        case .disabled:
            isEnabled = false
            layer.opacity = 2/3
            setTitle(title, for: .normal)
            spinner.stopAnimating()
        case .loading:
            isEnabled = false
            layer.opacity = 1
            setTitle("", for: .normal)
            spinner.startAnimating()
        }
    }
}

// MARK: - Setup

extension SaveButton {
    private func setup() {
        setTitle(title, for: .normal)

        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false

        spinner.anchor(centerY: centerYAnchor, centerX: centerXAnchor)
    }
}

// MARK: - ButtonState

extension SaveButton {
    enum ButtonState {
        case active
        case disabled
        case loading
    }
}
#endif
