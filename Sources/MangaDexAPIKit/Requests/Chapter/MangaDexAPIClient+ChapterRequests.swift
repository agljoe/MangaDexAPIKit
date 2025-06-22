//
//  MangaDexAPIClient+ChapterRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// Chapter requests.
public extension MangaDexAPIClient {
    /// Retrieves the chapter with the given ID.
    ///
    /// - Parameter id: the UUID of the chapter to fetch.
    ///
    /// - Returns: a `Result` containing the retrieved chapter or any errors that occured during the get operation.
    func getChapter(_ id: UUID) async -> Result<Chapter, Error> {
        await Task {
            try await self.withRateLimit {
                try await  Request<ChapterEntity>(.init(id: id)).execute()
            }
        }.result
    }
    
    /// Retrieves a large amount of chapters by making multiple requests, and combining their results.
    ///
    /// - Parameter ids: the UUIDs of the chatpers to fetch.
    ///
    /// - Returns: a `Result` containing an array of chatpers, or any errors that occured during the get operation.
    func getChapters(_ ids: [UUID]) async -> Result<[Chapter], Error> {
        guard !ids.isEmpty else {
            return .failure(MangaDexAPIError.badRequest(context: ("At least one or more chapter IDs must be provided.")))
        }
        
        let requestsToMake = ids.count > 100 ? (ids.count / 100) + 1 : 1
        
        var result = [Chapter]()
        
        for i in 0..<requestsToMake {
            do {
                let requestedChapters = Array(ids[i * 100..<((i + 1) * 100 > ids.count ? ids.count : (i + 1) * 100)])
                async let (chapters, _ , _) = self.withRateLimit {
                    try await ListRequest<ChapterListEntity>(
                        .init(
                            ids: requestedChapters,
                            limit: requestedChapters.count
                        )
                    ).execute()
                }
                result.append(contentsOf: try await chapters)
            } catch let error {
                return .failure(error)
            }
        }
        
        return .success(result)
    }
    
    /// Retrieves the chapters with the given IDs.
    ///
    /// - Parameters:
    ///     - ids: the UUIDs of the chapters to fetch.
    ///     - limit: the maximum amount of chapters to retrieve, up to 100 per request.
    ///     - offset: an amount to shift the retrieved collection's index.
    ///
    /// - Returns: a `Result` containing an array of chapters, the total size of the collection, and its offset,
    ///            or any errors that occured during the get operation.
    func getChapters(
        _ ids: [UUID],
        limit: Int? = nil,
        offset: Int? = nil
    ) async -> Result<([Chapter], Int, Int), Error>  {
        guard ids.count > 0 && ids.count <= 100 else {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested chapters must be between 1 and 100."))
        }
        
        if let limit = limit, limit < 0 || limit > 100 {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested chapters must be between 1 and 100."))
        }
        
        return await Task {
            try await self.withRateLimit {
                try await ListRequest<ChapterListEntity>(
                    .init(
                        ids: ids,
                        limit: limit ?? ids.count,
                        offset: offset ?? 0
                    )
                ).execute()
            }
        }.result
    }
    
    /// Retrieves the at home chapter compontents for the given chapter.
    ///
    /// - Parameter id: the UUID of a chapter.
    ///
    /// - Returns: a `Result` containing the retrieved chapter components, or any errors that occured during the get operation.
    func getChapterComponents(for id: UUID) async -> Result<AtHomeChapterComponents, Error> {
        await Task {
            try await self.withRateLimit {
                try await AtHomeRequest(for: id).execute()
            }
        }.result
    }
}
