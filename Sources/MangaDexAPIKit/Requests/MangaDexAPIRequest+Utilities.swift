//
//  MangaDexAPIRequest+Utilities.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// Custom JSON decoder.
extension MangaDexAPIRequest {
    /// Creates a JSONDecoder that uses RFC3339 as its date decoding strategy.
    ///
    /// - Returns: A  `JSONDecoder` with a custom dateDecodingStrategy.
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        RFC3339DateFormatter.timeZone = TimeZone.current
        decoder.dateDecodingStrategy = .formatted(RFC3339DateFormatter)
        
        return decoder
    }
}

/// HTTP error mapping.
extension MangaDexAPIRequest {
    /// Maps an `HTTPRespsonse` to the associated `MangaDexAPIError`
    /// - Parameters:
    ///     - response: an `HTTPURLResponse`
    ///     - context: a string describing the context in which the error happened
    ///
    /// - Returns: an associated `MangaDexAPIError`.
    func mapError(_ response: HTTPURLResponse, context: String) -> MangaDexAPIError {
        switch response.statusCode {
        case 400:
            return .badRequest(context: context)
        case 401:
            return .unauthorized(context: context)
        case 403:
            return .forbidden(context: context)
        case 404:
            return .notFound(context: context)
        case 429:
            return .tooManyRequests(context: context)
        case 500:
            return .interalServerError(context: context)
        case 503:
            return .serviceUnavailable(context: context)
        default:
            return .unknownResponse(context: context)
        }
    }
}

/// Standard HTTP request types.
extension MangaDexAPIRequest {
    
    /// Performs an HTTP GET request from a server for the given `url`.
    ///
    /// - Parameter url: a url that specifies the sever where the request is made.
    ///
    /// - Returns: the data from the server decoded as the specified `ModelType`.
    ///
    /// - Throws: a corresponding `MangaDexAPIError`  if the returned status code is not 200.
    public func get(from url: URL) async throws -> ModelType {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        request.timeoutInterval = 120
        
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw mapError((response as! HTTPURLResponse), context: "\(String(data: data, encoding: .utf8) ?? "no context available").")
        }
        
        return try decode(data)
    }
    
    /// Performs an HTTP POST request at a server for the given `url`.
    ///
    /// - Parameters:
    ///     - url: the url for a specific server.
    ///     - value: a string specifiying the value of the `Content-Type` header field.
    ///     - content: an encoded data value passed to a specified server as the request's body.
    ///
    /// - Important: The caller is responsible for encoding the data in the correct format, ensure the data being passed is correctly configured for the specified server.
    ///
    /// - Returns: a data value from the specified server.
    ///
    /// - Throws: a corresponding `MangaDexAPIError`  if the returned status code is not 200.
    public func post(
        at url: URL,
        forContentType value: String = "application/json",
        with content: Data? = nil
    ) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue(value, forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        request.timeoutInterval = 120
        request.httpMethod = "POST"
        
        if let body = content { request.httpBody = body }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw mapError((response as! HTTPURLResponse), context: "\(String(data: data, encoding: .utf8) ?? "no context available").")
        }
        
        return data
    }
}
