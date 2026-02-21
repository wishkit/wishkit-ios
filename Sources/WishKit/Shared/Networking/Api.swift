//
//  Api.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

struct Api: RequestCreatable {}

// MARK: - Generic Send Functions

extension Api {
    static func send<T: Decodable>(request: URLRequest) async -> ApiResult<T, ApiError> {
        let method = request.httpMethod ?? ""

        print("🌐 API | \(method) | \(request.url?.absoluteString ?? "nil")")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            // Date decoding standard used across frontend and backend.
            decoder.dateDecodingStrategy = .iso8601

            do {
                let object = try decoder.decode(T.self, from: data)
                return .success(object)
            } catch {
                printError(self, String(describing: error))
            }

            if let apiError = try? decoder.decode(ApiError.self, from: data) {
                printError(self, "\(apiError.reason.description).")
                return .failure(apiError)
            }

            printError(self, "Could not decode: \n\n \(String(data: data, encoding: .utf8) ?? "") \n")
            return .failure(ApiError(reason: .couldNotDecodeBackendResponse))
        } catch {
            printError(self, String(describing: error))
            return .failure(ApiError(reason: .requestResultedInError))
        }
    }
}
