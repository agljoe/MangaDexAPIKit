//
//  MangaDexAPIError.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-12.
//

import Foundation

/// An error response from the MangaDexApi.
///
/// The MangaDexApi specifies the exact repsonses for each enpoint, for more information see [MangaDex API Documentation](https://api.mangadex.org/docs/redoc.html).
public enum MangaDexAPIError: Error, Equatable, Hashable {
    /// HTTP error code 400.
    case badRequest(context: String)
    
    /// HTTP error code 401.
    case unauthorized(context: String)
    
    /// HTTP error code 403.
    case forbidden(context: String)
    
    /// HTTP error code 404.
    case notFound(context: String)
    
    /// HTTP error code 429.
    case tooManyRequests(context: String)
    
    /// HTTP error code 500.
    case interalServerError(context: String)
    
    /// HTTP error code 503.
    case serviceUnavailable(context: String)
    
    /// Invalid or malformed ULR.
    case invalidURL(context: String)
    
    /// A undocumented response from the MangaDexAPI.
    case unknownResponse(context: String)
}

extension MangaDexAPIError: LocalizedError {
    /// A descrtiption of how and why a given `MangaDexAPIError` occured.
    public var errorDescription: String? {
        switch self {
        case .badRequest(context: let context):
            return String(localized: "The request was malformed, contained invalid syntax or its body was too large. (\(context))")
        case .unauthorized(context: let context):
            return String(localized: "The client must be authorized to make this request. (\(context))")
        case .forbidden(context: let context):
            return String(localized: "The client does not have the necessary permissions to access the resource. (\(context))")
        case .notFound(context: let context):
            return String(localized: "The requested resource could not be found. (\(context))")
        case .tooManyRequests(context: let context):
            return String(localized: "Too many requests were made to the server in a short amount of time. (\(context))")
        case .interalServerError(context: let context):
            return String(localized: "The server encountered an unexpected condition that prevented it from fulfilling the request. (\(context))")
        case .serviceUnavailable(context: let context):
            return String(localized: "The requested service is currently unavailable. (\(context))")
        case .invalidURL(context: let components):
            return String(localized: "A URL could not be constructed from the provided components. (\(components))")
        case .unknownResponse(context: let context):
            return String(localized: "Unable to parse the response from the server. (\(context))")
        }
    }
}
