//
//  ReviewController.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/25/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit

final class ReviewController: UIViewController {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 8
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private let appIV: UIImageView = {
        let imageView = UIImageView(image: Bundle.main.appIcon)
        imageView.layer.cornerRadius = 8
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()

    private let titleLabel = UILabel("Enjoying \(Bundle.main.displayName ?? "The App")?", font: .boldSystemFont(ofSize: UIFont.labelFontSize))

    private let subtitleLabel = UILabel("Tap a star to rate it.")

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup

extension ReviewController {

    private func setup() {
        setupView()
        setupConstraints()
    }

    private func setupView() {
        view.addSubview(containerView)
        containerView.addSubview(stackView)

        stackView.addArrangedSubview(appIV)

    }

    private func setupConstraints() {

    }
}
#endif
