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

    public static var theme = Theme()

    public static var config = Configuration()

    #if canImport(UIKit)
    /// (UIKit) The WishList viewcontroller.
    public static var viewController: UIViewController {
        return WishListVC()
    }
    #endif
    
    /// (SwiftUI) The WishList view.
    public static var view: some View {
        #if os(macOS)
            return WishlistContainer(wishModel: WishModel())
        #else
            return WishListView()
        #endif
    }

    public static func configure(with apiKey: String) {
        WishKit.apiKey = apiKey
    }
}
