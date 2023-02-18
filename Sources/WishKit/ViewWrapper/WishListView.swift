//
//  WishListView.swift
//  wishkist-ios
//
//  Created by Martin Lasek on 2/17/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct WishListView: UIViewRepresentable {
  typealias UIViewType = UIView

  func makeUIView(context: Context) -> UIView {
    let vc = WishListVC()
    vc.viewDidLoad()
    return vc.view
  }

  func updateUIView(_ uiView: UIView, context: Context) { }
}
