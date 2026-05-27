//
//  RoundUp.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

import Foundation

final class RoundUp: NSDecimalNumberBehaviors {

    func scale() -> Int16 {
        0
    }

    func exceptionDuringOperation(
        _ operation: Selector,
        error: NSDecimalNumber.CalculationError,
        leftOperand: NSDecimalNumber,
        rightOperand: NSDecimalNumber?
    ) -> NSDecimalNumber? {
        0
    }

    func roundingMode() -> NSDecimalNumber.RoundingMode {
        .up
    }
}
