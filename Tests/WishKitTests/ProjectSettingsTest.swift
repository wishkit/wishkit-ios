//
//  ProjectSettingsTest.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/14/24.
//  Copyright © 2024 Martin Lasek. All rights reserved.
//

import XCTest

@testable import WishKit

class ProjectSettingsTest: XCTestCase {

    func testProjectSettings() {
        XCTAssertEqual(ProjectSettings.apiUrl, "https://www.wishkit.io/api")
    }
}

