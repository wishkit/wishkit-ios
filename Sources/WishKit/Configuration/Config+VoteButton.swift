//
//  Config+VoteButton.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/25/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

extension Configuration {
    public struct VoteButton {

        public var arrowColor: Theme.Scheme = .setBoth(to: .gray)
        
        public var textColor: Theme.Scheme = .set(light: .black, dark: .white)
    }
}
