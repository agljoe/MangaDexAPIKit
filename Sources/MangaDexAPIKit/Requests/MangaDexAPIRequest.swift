//
//  MangaDexAPIRequest.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// A request to the MangaDex API.
public protocol MangaDexAPIRequest: Sendable {
    /// The model type to be fetched by this request.
    associatedtype ModelType: Sendable
    
    /// Decodes the given data as the associated model type.
    ///
    /// - Parameter data: some JSON data to be decoded as `ModelType`.
    ///
    /// - Throws: some 'DecodingError'  if `data` cannot be decoded.
    ///
    /// - Returns: the decoded data as the specified model type.
    // @concurrent
    func decode(_ data: Data) /* async */ throws -> ModelType
    
    /// Executes this request
    func execute() async throws -> ModelType
}

