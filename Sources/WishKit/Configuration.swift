//
//  Configuraton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 3/8/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

public struct Configuration {

    public var showStatusBadge: Bool

    public init(showStatusBadge: Bool) {
        self.showStatusBadge = showStatusBadge
    }

    public static func `default`() -> Configuration {
        return Configuration(
            showStatusBadge: false
        )
    }
}
