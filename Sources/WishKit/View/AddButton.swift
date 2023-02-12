//
//  AddButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit

final class AddButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        backgroundColor = .systemGreen

        layer.cornerRadius = length/2
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.50
    }
}
