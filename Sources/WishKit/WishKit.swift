//
//  WishKit.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit
import SwiftUI

public struct WishKit {

    static var apiKey = "my-fancy-api-key"

    public static var theme: Theme = .default()

    /// (UIKit) The WishList viewcontroller.
    public static let viewController: UIViewController = WishListVC()

    /// (SwiftUI) The WishList view.
    public static let view: some View = WishListView().ignoresSafeArea(.container)

    public static func configure(with apiKey: String) {
        WishKit.apiKey = apiKey
    }
}

