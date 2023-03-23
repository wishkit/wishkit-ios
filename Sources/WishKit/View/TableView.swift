//
//  TableView.swift
//  mi-cuit-ios
//
//  Created by Martin Lasek on 3/23/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit

/// A dynamicly growing UITableView
final class TableView: UITableView {
  override var contentSize: CGSize {
    didSet { invalidateIntrinsicContentSize() }
  }

  override var intrinsicContentSize: CGSize {
    layoutIfNeeded()

    // I substract 1 here so that we don't see the rows bottom line of the last element.
    return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height - 1)
  }
}
