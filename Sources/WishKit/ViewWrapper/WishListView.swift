//
//  WishListView.swift
//  wishkist-ios
//
//  Created by Martin Lasek on 2/17/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct WishListView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let vc = WishList.viewController
        vc.viewDidLoad()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
