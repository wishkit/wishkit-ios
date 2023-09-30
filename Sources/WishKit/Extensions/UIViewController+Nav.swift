//
//  UIViewController+Navigation.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/30/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIViewController {
    public func withNavigation() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
#endif
