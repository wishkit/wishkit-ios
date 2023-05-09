//
//  RatingView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/30/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//
#if canImport(UIKit)
import UIKit

protocol RatingViewDelegate: AnyObject {
    func didTap(rating: RatingView.Rating)
}

final class RatingView: UIView {
    enum Rating: Int {
        case one, two, three, four, five
    }

    weak var delegate: RatingViewDelegate?

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        return stackView
    }()

    private lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension RatingView {
    private func setup() {
        setupView()
        setupConstraints()
    }

    private func setupView() {
        addSubview(stackView)
        stackView.addArrangedSubview(createStarButton(for: .one))
    }

    private func setupConstraints() {

    }

    private func createStarButton(for rating: Rating) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        button.tag = rating.rawValue
        return button
    }
}

// MARK: - Action

extension RatingView {
    @objc private func tapAction(sender: UIButton) {
        guard let rating = Rating(rawValue: sender.tag) else {
            return
        }

        delegate?.didTap(rating: rating)
    }
}
#endif
