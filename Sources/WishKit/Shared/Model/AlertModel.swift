//
//  AlertModel.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 9/27/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

final class AlertModel: ObservableObject {

    @Published
    var showAlert = false

    @Published
    var alertReason: AlertReason = .none
}
