//
//  AlertReason.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/21/26.
//  Copyright © 2026 Martin Lasek. All rights reserved.
//

enum AlertReason {

    case alreadyVoted

    case alreadyCompleted

    case voteReturnedError(String)

    case successfullyCreated

    case createReturnedError(String)

    case emailRequired

    case emailFormatWrong

    case none
}
