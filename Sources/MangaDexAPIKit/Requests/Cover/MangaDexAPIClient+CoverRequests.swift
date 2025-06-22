//
//  MangaDexAPIClient+CoverRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// Cover requests.
public extension MangaDexAPIClient {
    /// Retrieves the cover with the given ID.
    ///
    /// - Parameter id: the UUID of a cover.
    ///
    /// - Returns: a `Result` containing the retrieved chapter, or any errors that occured during the get operation.
    func getCover(_ id: UUID) async -> Result<Cover, Error> {
        await Task {
            try await self.rateLimiter.withToken {
                try await Request<CoverEntity>(.init(id: id)).execute()
            }
        }.result
    }
    
    /// Retrieves the cover with the given IDs.
    ///
    /// - Parameters:
    ///     - ids: the UUIDs of some cover.
    ///     - limit: the maximum amount of covers to retrieve, up to 100 per request.
    ///     - offset: an amount to shift the retrieved collection's index.
    ///
    /// - Returns: A `Result` containing an array of covers, the total size of the collection, and its offset,
    ///            or any errors that occured during the get operation.
    ///
    func getCovers(
        coverIDs ids: [UUID],
        limit: Int? = nil,
        offset: Int? = nil
    ) async -> Result<([Cover], Int, Int), Error>  {
        guard ids.count > 0 && ids.count <= 100 else {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested covers must be between 1 and 100."))
        }
        
        if let limit = limit, limit < 0 || limit > 100 {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested covers must be between 1 and 100."))
        }
        
        return await Task {
            try await self.withRateLimit {
                try await ListRequest<CoverListEntity>(
                    .init(
                        coverIDs: ids,
                        limit: limit ?? 10,
                        offset: offset ?? 0
                    )
                ).execute()
            }
        }.result
    }
    
    /// Retrieves all covers for the given manga.
    ///
    /// - Parameters:
    ///     - ids: the UUIDs of some manga.
    ///     - limit: the maximum amount of covers to retrieve, up to 100 per request.
    ///     - offset: an amount to shift the retrieved collection's index.
    ///
    /// - Returns: a `Result` containing an array of covers, the total size of the collection, and its offset,
    ///            or any errors that occured during the get operation.
    func getCovers(
        mangaIDs ids: [UUID],
        limit: Int? = nil,
        offset: Int? = nil
    ) async -> Result<([Cover], Int, Int), Error>  {
        guard ids.count > 0 && ids.count <= 100 else {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested covers must be between 1 and 100"))
        }
        
        if let limit = limit, limit < 0 || limit > 100 {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested covers must be between 1 and 100."))
        }
        
        return await Task {
            try await self.withRateLimit {
                try await ListRequest<CoverListEntity>(
                    .init(
                        mangaIDs: ids,
                        limit: limit ?? 10,
                        offset: offset ?? 0
                    )
                ).execute()
            }
        }.result
    }
    
    /// Retrieves the latest covers for the given manga.
    ///
    /// - Parameters:
    ///     - ids: the UUIDs of some manga.
    ///     - limit: the maximum amount of covers to retrieve, up to 100 per request.
    ///     - offset: an amount to shift the retrieved collection's index.
    ///
    /// - Returns: a `Result` containing an array of cover, manga UUID pairs, or
    ///            any errors that occured during the get operation.
    func getCovers(
        for ids: [UUID],
        limit: Int? = nil,
        offset: Int? = nil
    ) async -> Result<[(Cover, UUID)], Error> {
        guard ids.count > 0 && ids.count <= 100 else {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested covers must be between 1 and 100"))
        }
        
        if let limit = limit, limit < 0 || limit > 100 {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested chapters must be between 1 and 100."))
        }
        
        return await Task {
            try await self.withRateLimit {
                try await CoverListFromMangaRequest(
                    .init(
                        ids: ids,
                        limit: limit ?? ids.count,
                        offset: offset ?? 0
                    )
                ).execute()
            }
        }.result
    }
}
