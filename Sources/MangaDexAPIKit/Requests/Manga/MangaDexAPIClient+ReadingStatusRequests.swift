//
//  MangaDexAPIClient+ReadingStatusRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-17.
//

import Foundation

/// Reading status requests.
public extension MangaDexAPIClient {
    /// Retrieves the user's current reading status for a given manga.
    ///
    /// - Parameter manga: the UUID of a manga.
    ///
    /// - Returns: a `Result` containing a string describing the reading status for the specified manga,
    ///             or any errors that occured during the get operation.
    func getReadingStatus(for manga: UUID) async -> Result<String, Error> {
        await Task {
            try await self.withRateLimit {
                try await MangaReadingStatusRequest(for: manga).execute()
            }
        }.result
    }
    
    /// Retrieves all manga the user has set a reading status for.
    ///
    /// - Returns: a `Result` containing  dictionary with every manga reading status, where the key is a manga's UUID string,
    ///            or any errors that occured durning the get operation.
    func getAllReadingStatus() async throws -> Result<[String: String], Error> {
        await Task {
            try await self.withRateLimit {
                try await AllMangaReadingStatusRequest().execute()
            }
        }.result
    }
    
    /// Sets the reading status for a given manga.
    ///
    /// - Parameters:
    ///   - manga: the UUID of a manga.
    ///   - status: the status that given manga will be updated to.
    ///
    /// - Returns: a `Result` conatining a response if the specifed manga's reading status was successfully updated,
    ///            or any errors that occured during the post operation.
    func updateReadingStatus(
        for manga: UUID,
        to status: ReadingStatus
    ) async -> Result<Response, Error> {
        await Task {
            try await self.withRateLimit {
                try await UpdateMangaReadingStatusRequest(
                    for: manga,
                    to: status
                ).execute()
            }
        }.result
    }
}
