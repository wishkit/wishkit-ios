//
//  Api.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation
import WishKitShared

struct Api: RequestCreatable {
    enum Version: String {
        case v1
    }
}

enum ApiResult<Success, Error> {
    case success(Success)
    case failure(Error)
}

// MARK: - Generic Send Functions

extension Api {
    /// Generic Send Function. You need to specify the Result<T, Error> type to help inferring it.
    /// e.g: Api.send(request: resetRequest) { (result: Result<ResetPasswordResponse, ApiError.Kind>) in ... }
    static func send<T: Decodable>(request: URLRequest, completionHandler: @escaping (ApiResult<T, ApiError>) -> Void) {
        let method = request.httpMethod ?? ""

        print("🌐 API | \(method) | \(request.url?.absoluteString ?? "nil")")

        URLSession.shared.dataTask(with: request) { data, resp, error in
            // Early return in case of error.
            if let error = error {
                printError(self, error.localizedDescription)
                completionHandler(.failure(ApiError(reason: .requestResultedInError)))
                return
            }

            guard let data = data else {
                printError(self, "data was nil.")
                completionHandler(.failure(ApiError(reason: .unknown)))
                return
            }

            let decoder = JSONDecoder()
            // Date Decoding Standard used across frontend and backend.
            decoder.dateDecodingStrategy = .millisecondsSince1970
            if let restaurant = try? decoder.decode(T.self, from: data) {
                completionHandler(.success(restaurant))
                return
            }

            if let apiError = try? decoder.decode(ApiError.self, from: data) {
                printError(self, "\(apiError.reason.description).")
                completionHandler(.failure(apiError))
                return
            }

            printError(self, String(data: data, encoding: .utf8) ?? "")
            completionHandler(.failure(ApiError(reason: .couldNotDecodeBackendResponse)))
        }.resume()
    }

    /// Generic Send Function. You need to specify the Result<T, Error> type to help inferring it.
    /// e.g: Api.send(request: resetRequest) { (result: Result<ResetPasswordResponse, ApiError.Kind>) in ... }
    static func send<T: Decodable>(request: URLRequest) async -> ApiResult<T, ApiError> {
        let method = request.httpMethod ?? ""

        print("🌐 API | \(method) | \(request.url?.absoluteString ?? "nil")")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            // Date Decoding Standard used across frontend and backend.
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
            printError(self, error.localizedDescription)
            return .failure(ApiError(reason: .requestResultedInError))
        }
    }
}

