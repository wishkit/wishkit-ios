//
//  Api.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

struct Api: RequestCreatable {
    enum Version: String {
        case v1
    }
}

// MARK: - Generic Send Functions

extension Api {
    /// Generic Send Function. You need to specify the Result<T, Error> type to help inferring it.
    /// e.g: Api.send(request: resetRequest) { (result: Result<ResetPasswordResponse, ApiError.Kind>) in ... }
    static func send<T: Decodable>(request: URLRequest, completionHandler: @escaping (Result<T, ApiError.Kind>) -> Void) {
        let method = request.httpMethod ?? ""

        print("🌐 API (\(method)) Request to: \(request.url?.absoluteString ?? "nil")")
        
        URLSession.shared.dataTask(with: request) { data, resp, error in
            // Early return in case of error.
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(.noConnectionToTheServer))
                return
            }

            guard let data = data else {
                completionHandler(.failure(.unKnown))
                return
            }

            let decoder = JSONDecoder()
            // Date Decoding Standard used across frontend and backend.
            decoder.dateDecodingStrategy = .millisecondsSince1970
            if let restaurant = try? decoder.decode(T.self, from: data) {
                completionHandler(.success(restaurant))
                return
            }

            if let backendError = try? decoder.decode(ApiError.Backend.self, from: data) {
                let error = ApiError.Kind(rawValue: backendError.reason) ?? ApiError.Kind.unKnown
                if error == .unKnown {
                    printError(self, "Could not decode error. Error: \(backendError.reason).")
                }
                completionHandler(.failure(error))
                return
            }

            print(String(data: data, encoding: .utf8) ?? "")
            completionHandler(.failure(ApiError.Kind.couldNotDecodeBackendResponse))
        }.resume()
    }
}

