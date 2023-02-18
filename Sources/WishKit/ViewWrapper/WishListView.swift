//
//  WishListView.swift
//  wishkist-ios
//
//  Created by Martin Lasek on 2/17/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct WishListView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let vc = WishList.viewController
        vc.viewDidLoad()
        // Add nav
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
