//
//  Config+Button.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/25/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

extension Configuration {
    public struct Buttons {

        public let segmentedControl: SegmentedControl

        public var addButton: AddButton

        public let voteButton: VoteButton

        init(
            segmentedControl: SegmentedControl = SegmentedControl(),
            addButton: AddButton = AddButton(),
            voteButton: VoteButton = VoteButton()
        ) {
            self.segmentedControl = segmentedControl
            self.addButton = addButton
            self.voteButton = voteButton
        }
    }
}
