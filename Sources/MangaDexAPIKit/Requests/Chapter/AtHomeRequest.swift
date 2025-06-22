//
//  AtHomeRequest.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// Represents a request to the at-home endpoint which is the only endpoint where chapter
/// images can be found.
public struct AtHomeRequest {
    /// The chapter images being retrieved.
    fileprivate let entity: ChapterImageEntity
    
    /// Creates a new instance from the given entity.
    ///
    /// - Parameter id: the id used to initialize the`ChapterImageEntity` for this request.
    ///
    /// - Returns: a newly created AtHomeRequest for the given id..
    public init(for id: UUID) {
        self.entity = ChapterImageEntity(id: id)
    }
}

extension AtHomeRequest: MangaDexAPIRequest {
    public typealias ModelType = AtHomeChapterComponents
    
    public func decode(_ data: Data) throws -> AtHomeChapterComponents {
        return try JSONDecoder().decode(AtHomeChapterComponents.self, from: data)
    }
    
    public func execute() async throws -> AtHomeChapterComponents {
        return try await get(from: entity.url)
    }
    
}
