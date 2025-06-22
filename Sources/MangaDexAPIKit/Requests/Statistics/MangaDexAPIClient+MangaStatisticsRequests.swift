//
//  MangaDexAPIClinet+MangaStatisticsRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-17.
//

import Foundation

/// Manga statistics request.
public extension MangaDexAPIClient {
    /// Retrieves the ratings, comments and total follows of a manga.
    ///
    /// - Parameter manga: the UUID of the manga whose statistics are being retireved.
    ///
    /// - Returns: a `Result` containing the retrieved statistics or any errors that occured during the get operation.
    func getStatistics(for manga: UUID) async -> Result<MangaStatistics, Error> {
        await Task {
            try await self.withRateLimit {
                try await MangaStatisticsRequest(for: manga).execute()
            }
        }.result
    }
    
    /// Retrieves the ratings, comments and total follows of some manga.
    ///
    /// - Parameter manga: the UUIDs of the manga whose statistics are being retireved.
    ///
    /// - Returns: a `Result` containing a dictionary with statistics for the given chatpers, where the key is a manga's UUID string,
    ///            or any errors that occured during the get operation.
    func getStatisics(for manga: [UUID]) async -> Result<[String: MangaStatistics], Error> {
        await Task {
            try await self.withRateLimit {
                try await GroupedMangaStatisticsRequest(ids: manga).execute()
            }
        }.result
    }
}
