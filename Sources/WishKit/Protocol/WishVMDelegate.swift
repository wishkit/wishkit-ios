//
//  WishVMDelegate.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit

protocol WishVMDelegate: AnyObject {

    func listWasUpdated()

    func didSelect(wishResponse: SingleWishResponse)
}

extension WishVMDelegate where Self: UIViewController { }
