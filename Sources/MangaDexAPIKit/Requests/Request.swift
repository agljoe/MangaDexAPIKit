//
//  Request.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// A generic request that fetches the entity specified by `T`.
public struct Request<T: MangaDexAPIEntity>: Sendable, MangaDexAPIRequest {
    /// The entity being retrieved by this request.
    let entity: T
    
    /// Creates a new request for the given entity.
    ///
    /// - Parameter entity: a MangaDexAPI entity being retrieved.
    ///
    /// - Returns: a newly created `Request` for the given entity.
    init(_ entity: T) {
        self.entity = entity
    }

    public func decode(_ data: Data) throws -> T.ModelType {
        return try decoder().decode(Wrapper<T.ModelType>.self, from: data).data
    }
    
    public func execute() async throws -> T.ModelType {
        if entity.requiresAuthentication { return try await authenticatedGet(from: entity.url) }
        return try await get(from: entity.url)
    }
}

/// A generic request that fetches a list from the entity specified by `T`.
///
/// - Important: List requests should be made with this request type, unless the offset of the collection can be discarded.
public struct ListRequest<T: MangaDexAPIEntity>: Sendable {
    /// The entity being retrieved by this request.
    let entity: T
    
    /// Creates a new request for the given entity.
    ///
    /// - Parameter entity: a MangaDexAPI entity being retrieved.
    ///
    /// - Returns: a newly created `ListRequest` for the given entity.
    init(_ entity: T) {
        self.entity = entity
    }
}

extension ListRequest: MangaDexAPIRequest {
    public typealias ModelType = (T.ModelType, Int, Int)
    
    public func decode(_ data: Data) throws -> (T.ModelType, Int, Int) {
        let result = try decoder().decode(Wrapper<T.ModelType>.self, from: data)
        return (result.data, result.offset ?? 0, result.total ?? 0)
    }
    
    public func execute() async throws -> (T.ModelType, Int, Int) {
        if entity.requiresAuthentication { return try await authenticatedGet(from: entity.url) }
        return try await get(from: entity.url)
    }
}

