//
//  File.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// A request that returns the statistics for a specific manga
public struct MangaStatisticsRequest: MangaDexAPIRequest {
    /// The entity whose statistics are being retieved.
    fileprivate let entity: MangaStatisticsEntity
    
    /// Creates a new instance with the given id.
    ///
    /// This request initalizes its own entity to ensure that a `MangaStatisicsEntity`
    /// is not accidentally passed with a genereic request.
    ///
    /// - Parameter id: The UUID of a manga.
    ///
    /// - Returns: a newly created `MangaStatisticsRequest` for the given chapter UUID.
    init(for id: UUID) {
        self.entity = .init(id: id)
    }
}

public extension MangaStatisticsRequest {
    typealias ModelType = MangaStatistics
    
    func decode(_ data: Data) throws -> MangaStatistics {
        return try JSONDecoder().decode(StatisticsWrapper<MangaStatistics>.self, from: data).statistics
    }
    
    func execute() async throws -> MangaStatistics {
        return try await get(from: entity.url)
    }
}


/// A request that returns the statistics of multiple manga.
///
/// Grouped statistics are stored as a dictionary with the key being the UUID of the manga for each value respectively.
public struct GroupedMangaStatisticsRequest: MangaDexAPIRequest {
    /// The entity whose statistics are being retrieved.
    fileprivate let entity: GroupedMangaStatisticsEntity
    
    /// Creates a new instance with the given ids.
    ///
    /// - Parameter ids: the UUIDs of some manga.
    ///
    /// - Returns: a newly created `GroupedMangarStatisticsRequest`.
    init(ids: [UUID]) {
        self.entity = .init(ids: ids)
    }
    
    /// Convience initializer that accpects a variadic list of UUIDs.
    ///
    /// - Parameter ids: the UUIDs of some chapters.
    ///
    /// - Returns: a newly created `GroupedMangarStatisticsRequest`.
    init(ids: UUID...) {
        self.init(ids: ids)
    }
}

public extension GroupedMangaStatisticsRequest {
    typealias ModelType = [String: MangaStatistics]
    
    func decode(_ data: Data) throws -> [String : MangaStatistics] {
        return try JSONDecoder().decode(GroupedStatisticsWrapper<MangaStatistics>.self, from: data).statistics
    }
    
    func execute() async throws -> [String : MangaStatistics] {
        return try await get(from: entity.url)
    }
}

