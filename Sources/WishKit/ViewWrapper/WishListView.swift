//
//  WishListView.swift
//  wishkist-ios
//
//  Created by Martin Lasek on 2/17/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

public struct WishListView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = UIViewController
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        let vc = WishKit.viewController
        vc.viewDidLoad()
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
