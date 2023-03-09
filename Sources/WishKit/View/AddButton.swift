//
//  AddButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit

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
        imageView?.tintColor = .white
        backgroundColor = WishKit.theme.primaryColor

        layer.cornerRadius = length/2
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.50
    }
}
#endif
