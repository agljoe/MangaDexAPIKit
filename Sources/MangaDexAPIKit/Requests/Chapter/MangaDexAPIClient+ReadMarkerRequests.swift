//
//  MangaDexAPIClient+ReadMarkerRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// Read marker requests.
public extension MangaDexAPIClient {
    /// Retrieves the UUIDs of all chapters that have been read for the given manga.
    ///
    /// - Parameter id: the UUID of a manga.
    ///
    /// - Returns: a `Result` containing an arrary of UUID strings of all chapters that have been read, or any errors that occured during the get operation.
    func getReadMarker(_ id: UUID) async -> Result<[String], Error> {
        await Task {
            try await self.withRateLimit {
                try await Request<ReadMarkerEntity>(.init(id: id)).execute()
            }
        }.result
    }
    
    /// Retrieves the UUIDs of all chapters that have been read for the given manga.
    ///
    /// - Parameter ids: the UUID of some manga.
    ///
    /// - Returns: a `Result` containong  a dictionary containing the UUID strings of all chapters that have been read, where the key is its parent manga's UUID string
    ///            or any errors that occured during the get operations.
    func getReadMarkers(_ ids: [UUID]) async -> Result<[String: [String]], Error> {
        await Task {
            try await self.withRateLimit {
                try await Request<ReadMarkerGroupEntity>(.init(ids: ids)).execute()
            }
        }.result
    }
    
    /// Sets the read markers of the chapers for the specified manga.
    ///
    /// - Parameters:
    ///     - mangaID: the UUID of the manga the given chapters belong to.
    ///     - readChapters: the chapters whose read markers will be set to read.
    ///     - unreadChapters: the chapters whose read markers will be set to undread.
    ///
    /// - Returns: a `Result` containing an optional `Result` or any errors that occured during the post operation.
    @discardableResult
    func updateReadMarkers(
        mangaID: UUID,
        readChapters: [UUID]? = nil,
        unreadChapters: [UUID]? = nil
    ) async -> Result<Response?, Error> {
        await Task {
            try await self.withRateLimit {
                try await UpdateReadMarkerRequest(
                    mangaID: mangaID,
                    chapterIdsRead: readChapters,
                    chapterIdsUnread: unreadChapters
                ).execute()
            }
        }.result
    }
}
