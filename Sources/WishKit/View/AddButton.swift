//
//  AddButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import SwiftUI

final class AddButton: UIButton {

    override init(frame: CGRect) {
        // By using the same width/height as used with auto layout.
        // There's no constraint conflicts with `_UITemporaryLayoutWidth`.
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View

    private func setupView() {
        let length: CGFloat = 60
        anchor(size: CGSize(width: length, height: length))

        let image = UIImage(systemName: "plus")
        setImage(image, for: .normal)
        backgroundColor = UIColor(WishKit.theme.primaryColor)
        layer.cornerRadius = length/2
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.50

        setupTheme()
    }
}

// MARK: - Theme

extension AddButton {
    private func setupTheme() {
        let textColor = WishKit.config.buttons.addButton.textColor
        if traitCollection.userInterfaceStyle == .light {
            imageView?.tintColor = UIColor(textColor.light)
        }

        if traitCollection.userInterfaceStyle == .dark {
            imageView?.tintColor = UIColor(textColor.dark)
        }
    }
}

extension AddButton {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard
            let previousTraitCollection = previousTraitCollection
        else {
            return
        }

        let textColor = WishKit.config.buttons.addButton.textColor
        if traitCollection.userInterfaceStyle == previousTraitCollection.userInterfaceStyle {
            if previousTraitCollection.userInterfaceStyle == .light {
                imageView?.tintColor = UIColor(textColor.light)
            }

            if previousTraitCollection.userInterfaceStyle == .dark {
                imageView?.tintColor = UIColor(textColor.dark)
            }
        } else {
            if previousTraitCollection.userInterfaceStyle == .light {
                imageView?.tintColor = UIColor(textColor.dark)
            }

            if previousTraitCollection.userInterfaceStyle == .dark {
                imageView?.tintColor = UIColor(textColor.light)
            }
        }
    }
}
#endif
