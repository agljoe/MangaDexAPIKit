//
//  MangaDexAPIClient+ChapterStatisticsRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-17.
//

import Foundation

/// Chapter statistics requests.
public extension MangaDexAPIClient {
    /// Retrieves the comments count for the given chatper.
    ///
    /// - Parameter chapter: the UUID of the chapter whose statistics are being retireved.
    ///
    /// - Returns: a `Result` containing the retrieved statistics or any errors that occured during the get operation.
    func getStatistics(for chapter: UUID) async -> Result<ChapterStatistics, Error> {
        await Task {
            try await self.withRateLimit {
                try await ChapterStatisticsRequest(for: chapter).execute()
            }
        }.result
    }
    
    /// Retrieves the comments count for the given chatpers.
    ///
    /// - Parameter chapters: the UUIDs of the chapters whose statistics are being retireved.
    ///
    /// - Returns: a `Result` containing a dictionary with statistics for the given chatpers, where the key is a chapter's UUID string,
    ///            or any errors that occured during the get operation.
    func getStatistics(for chapters: [UUID]) async -> Result<[String: ChapterStatistics], Error> {
        await Task {
            try await self.withRateLimit {
                try await GroupedChapterStatisticsRequest(ids: chapters).execute()
            }
        }.result
    }
}
