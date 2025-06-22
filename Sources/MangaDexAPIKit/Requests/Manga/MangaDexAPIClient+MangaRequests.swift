//
//  MangaDexAPIClient+MangaRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-17.
//

import Foundation

/// Manga requests.
public extension MangaDexAPIClient {
    /// Retrieves the manga with the specified UUID.
    ///
    /// - Parameter id: the UUID the manga to retrieve.
    ///
    /// - Returns: a `Result` containing the retrieved manga or any errors that occured during the get operation.
    func getManga(_ id: UUID) async -> Result<Manga, Error> {
        await Task {
            try await self.withRateLimit {
                try await Request<MangaEntity>(.init(id: id)).execute()
            }
        }.result
    }
    
    /// Retrieves a large number of manga by making multiple requests, and combining their result.
    ///
    /// - Parameter ids: the UUIDs of the manga being retrieved.
    ///
    /// - Returns: a `Result` contianing an array of manga, or any errors that occured during the get operation.
    func getManga(_ ids: [UUID]) async -> Result<[Manga], Error> {
        guard !ids.isEmpty else {
            return .failure(MangaDexAPIError.badRequest(context: "At least one or more IDs must be provided."))
        }
        
        let requestsToMake = ids.count > 100 ? (ids.count / 100) + 1 : 1
        
        var result = [Manga]()
        
        for i in 0..<requestsToMake {
            do {
                let requestedManga = Array(ids[i * 100..<((i + 1) * 100 > ids.count ? ids.count : (i + 1) * 100)])
                async let (manga, _, _) = self.withRateLimit {
                    try await ListRequest<MangaListEntity>(
                        .init(
                            ids: requestedManga,
                            limit: requestedManga.count
                        )
                    ).execute()
                }
                result.append(contentsOf: try await manga)
            } catch let error {
                return .failure(error)
            }
        }
       
        return .success(result)
    }
    
    /// Retrieves the magna with the spcified UUIDs.
    ///
    /// - Parameters:
    ///     - ids: the UUIDs of the manga being retrieved.
    ///     - limit: the maximum number of manga to retrieve.
    ///     - offset: an amount to shift the retrieved collection's index.
    ///
    /// - Returns: a `Result` containing an array of manga, the size of the collection, and its offset,
    ///            any errors that occured during the get operation.
    func getManga(
        _ ids: [UUID],
        limit: Int? = nil,
        offset: Int? = nil
    ) async -> Result<([Manga], Int, Int), Error> {
        guard ids.count > 0 && ids.count <= 100 else {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested manga must be between 1 and 100."))
        }
        
        if let limit = limit, limit < 0 || limit > 100 {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested manga must be between 1 and 100."))
        }
        
        return await Task {
            try await self.withRateLimit {
                try await ListRequest<MangaListEntity>(
                    .init(
                        ids: ids,
                        limit: limit ?? ids.count,
                        offset: offset ?? 0
                    )
                ).execute()
            }
        }.result
    }
    
    /// Retrieves a random manga.
    ///
    /// - Returns: a `Result` conatining a random manga that abides by a user's content prefernces,
    ///            or any errors that occured during the get operation.
    func getRandomManga() async -> Result<Manga, Error> {
        await Task {
            try await self.withRateLimit {
                try await Request<RandomMangaEntity>(.init()).execute()
            }
        }.result
    }
    
    /// Retrieves upto 100 chapters of a given manga.
    ///
    /// - Parameters:
    ///     - manga: the UUID of the manga whose chapters are being retrieved.
    ///     - limit: the maximum number of chapters to retrieve, 100 by default.
    ///     - offset:  an amount to shift the retrieved collection's index.
    ///
    /// - Returns: a `Result` containing an array of chapters, the total size of the collection, and its offset,
    ///            or any errors that occured during the get operation.
    func getChapters(
        for manga: UUID,
        limit: Int? = nil,
        offset: Int? = nil
    ) async -> Result<([Chapter], Int, Int), Error> {
        if let limit = limit, limit < 0 || limit > 100 {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested chapters must be between 1 and 100."))
        }
        
        return await Task {
            try await self.withRateLimit {
                try await ListRequest<MangaFeedEntity>(
                    .init(
                        id: manga,
                        limit: limit ?? 100,
                        offset: offset ?? 0
                    )
                ).execute()
            }
        }.result
    }
    
    /// Retrieves all available chapters for a specified manga.
    ///
    /// - Parameter manga: the UUID of the manga whose chapters are being retrieved.
    ///
    /// - Returns: a `Result` containing an array of chapters, or any errors that occured during the get operation.
    func getAllChapters(for manga: UUID) async -> Result<[Chapter], Error> {
        var lastTotal = 0
        
        var result = [Chapter]()
        
        while(lastTotal >= 100) {
            do {
                let offset = lastTotal
                async let (chapters, _, total) = self.withRateLimit {
                    try await ListRequest<MangaFeedEntity>(
                        .init(
                            id: manga,
                            limit: 100,
                            offset: offset
                        )
                    ).execute()
                }
                result.append(contentsOf: try await chapters)
                lastTotal = try await total
            } catch let error {
                return .failure(error)
            }
        }
        
        return .success(result)
    }
}
