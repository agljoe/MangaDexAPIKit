//
//  File.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-13.
//

import Foundation

/// A generic response found at endpoints that do not return any data.
public struct Response: Decodable, Sendable {
    /// The result of an operation, usually either "OK", or "Error".
    let result: String
}

/// Nested error context found in an error response JSON.
public struct MangaDexAPIErrorResponse: Decodable, Sendable {
    /// The id associated with this error.
    let id: String
    
    /// The HTTP status code for this error.
    let status: Int
    
    /// The MangaDexAPI's name for this error.
    let title: String
    
    /// Additional details explaining the causes of this error.
    let detail: String?
    
    /// The circumstances which caused this error to occur.
    let context: String?
}

/// A generic error response from the MangaDexAPI.
public struct ErrorResponse: Decodable, Sendable {
    /// A string that whose value is "error".
    let result: String
    
    /// The errors returned from the requested endpoint.
    let errors: [MangaDexAPIErrorResponse]
}
