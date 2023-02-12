//
//  ContainerView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit

final class ContainerView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    traitCollectionDidChange(nil)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    backgroundColor = .white
    layer.cornerRadius = 16
    layer.cornerCurve = .continuous
    layer.shadowRadius = 4
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: 3)
    layer.masksToBounds = false
  }
}
