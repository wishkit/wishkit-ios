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

    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 8
        return view
    }()
}
#endif
