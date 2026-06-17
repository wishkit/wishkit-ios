//
//  UUIDManager.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

struct UUIDManager {

    private static let slug = "wishkit"

    private static let userUUIDKey = "\(slug)-user-uuid"

    static func store(uuid: UUID) {
        UserDefaults.standard.set(uuid.uuidString, forKey: userUUIDKey)
    }

    static func getUUID() -> UUID {
        if
            let uuidString = UserDefaults.standard.string(forKey: userUUIDKey),
            let uuid = UUID(uuidString: uuidString)
        {
            return uuid
        }

        let uuid = UUID()

        store(uuid: uuid)

        return uuid
    }

    static func deleteUUID() {
        UserDefaults.standard.removeObject(forKey: userUUIDKey)
    }
}
