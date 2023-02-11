//
//  AlertManager.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import UIKit

struct AlertManager {

    /// Displays a message and either executes action on "Confirm" or cancels it on "Cancel".
    static func confirmAction(on vc: UIViewController, message: String, action: @escaping () -> Void) {
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in action() }
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        vc.present(alertController, animated: true)
    }

    /// Displays a message and dismisses on tapping "Ok".
    static func confirmMessage(on vc: UIViewController, message: String) {
        let title = "Info"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(confirmAction)
        vc.present(alert, animated: true)
    }
}
