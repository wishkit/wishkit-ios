//
//  RequestCreatable.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

protocol RequestCreatable {}

extension RequestCreatable {

    /// Create a POST request with JSON body
    static func createPOSTRequest<T: Encodable>(to url: URL, with body: T) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.jsonEncode(body)
        return request
    }

    /// Create a GET request
    static func createGETRequest(to url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

    /// Create a PATCH request with JSON body
    static func createPATCHRequest<T: Encodable>(to url: URL, with body: T) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.jsonEncode(body)
        return request
    }

    /// Create a DELETE request
    static func createDELETERequest(to url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return request
    }

    // MARK: - Authed URLRequests

    static func createAuthedPOSTReuqest<T: Encodable>(to url: URL, with body: T) -> URLRequest {
        var request = createPOSTRequest(to: url, with: body)
        request.addAuth()
        return request
    }

    static func createAuthedGETReuqest(to url: URL) -> URLRequest {
        var request = createGETRequest(to: url)
        request.addAuth()
        return request
    }

    static func createAuthedPATCHReuqest<T: Encodable>(to url: URL, with body: T) -> URLRequest {
        var request = createPATCHRequest(to: url, with: body)
        request.addAuth()
        return request
    }

    static func createAuthedDELETERequest(to url: URL) -> URLRequest {
        var request = createDELETERequest(to: url)
        request.addAuth()
        return request
    }
}

extension URLRequest {

    /// Adds User UUID and Bearer token to URLRequest if given.
    mutating func addAuth() {
        let uuid = UUIDManager.getUUID()
        let token = WishKit.apiKey
        self.setValue(token, forHTTPHeaderField: "x-wishkit-api-key")
        self.setValue(uuid.uuidString, forHTTPHeaderField: "x-wishkit-uuid")
    }

    /// Encodes instance into JSON and stets json headers.
    mutating func jsonEncode<T: Encodable>(_ body: T) {
        httpBody = try? JSONEncoder().encode(body)
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        addValue("application/json", forHTTPHeaderField: "Accept")
    }
}
