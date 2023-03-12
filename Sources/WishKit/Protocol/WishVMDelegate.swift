//
//  WishVMDelegate.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import WishKitShared

protocol WishVMDelegate: AnyObject {

    func listWasUpdated()

    func didSelect(wishResponse: WishResponse)
}

extension WishVMDelegate where Self: UIViewController { }
#endif
