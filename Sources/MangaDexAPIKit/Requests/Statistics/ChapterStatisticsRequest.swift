//
//  ChapterStatisticsRequest.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// A request that returns the statistics for a specific chapter
public struct ChapterStatisticsRequest {
    /// The entity whose statistics are being retieved.
    fileprivate let entity: ChapterStatisticsEntity
    
    /// Creates a new instance with the given id.
    ///
    /// This request initalizes its own entity to ensure that a `ChapterStatisticsEntity`
    /// is not accidentally passed with a genereic request.
    ///
    /// - Parameter id: The UUID of the a chatper.
    ///
    /// - Returns: a newly created `ChapterStatisticsRequest` for the given chapter UUID.
    public init(for id: UUID) {
        self.entity = .init(id: id)
    }
}

extension ChapterStatisticsRequest: MangaDexAPIRequest {
    public typealias ModelType = ChapterStatistics
    
    public func decode(_ data: Data) throws -> ChapterStatistics {
        return try JSONDecoder().decode(StatisticsWrapper<ChapterStatistics>.self, from: data).statistics
    }
    
    public func execute() async throws -> ChapterStatistics {
        return try await get(from: entity.url)
    }
}

/// A request that returns the statistics of multiple chapters.
///
/// Grouped statistics are stored as a dictionary with the key being the UUID of the chapter for each value respectively.
public struct GroupedChapterStatisticsRequest {
    /// The entity whose statistics are being retrieved.
    fileprivate let entity: GroupedChapterStatisticsEntity
    
    /// Creates a new instance with the given ids.
    ///
    /// - Parameter ids: the UUIDs of some chapters.
    ///
    /// - Returns: a newly created `GroupedChapterStatisticsRequest`.
   public init(ids: [UUID]) {
        self.entity = .init(ids: ids)
    }
    
    /// Convience initializer that accpects a variadic list of UUIDs.
    ///
    /// - Parameter ids: the UUIDs of some chapters .
    ///
    /// - Returns: a newly created `GroupedChapterStatisticsRequest`.
    public init(ids: UUID...) {
        self.init(ids: ids)
    }
}

extension GroupedChapterStatisticsRequest: MangaDexAPIRequest {
    public typealias ModelType = [String: ChapterStatistics]
    
    public func decode(_ data: Data) throws -> [String : ChapterStatistics] {
        return try JSONDecoder().decode(GroupedStatisticsWrapper<ChapterStatistics>.self, from: data).statistics
    }
    
    public func execute() async throws -> [String : ChapterStatistics] {
        return try await get(from: entity.url)
    }
}
