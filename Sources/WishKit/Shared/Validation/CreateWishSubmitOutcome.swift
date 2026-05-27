//
//  CreateWishSubmitOutcome.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

enum CreateWishSubmitOutcome: Equatable {

    case success

    case emailRequired

    case emailFormatWrong

    case createReturnedError(String)
}
