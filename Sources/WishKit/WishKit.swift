//
//  WishKit.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif

import SwiftUI

public struct WishKit {

    static var apiKey = "my-fancy-api-key"

    public static var theme: Theme = .default()

    public static var configuration: Configuration = .default()

    #if canImport(UIKit)
    /// (UIKit) The WishList viewcontroller.
    public static let viewController: UIViewController = WishListVC()
    #endif
    /// (SwiftUI) The WishList view.
    public static let view: some View = WishlistContainer()

    public static func configure(with apiKey: String) {
        WishKit.apiKey = apiKey
    }
}
