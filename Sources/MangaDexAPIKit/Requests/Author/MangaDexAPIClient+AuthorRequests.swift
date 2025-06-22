//
//  MangaDexAPIClient+AuthorRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// Author and artist requests.
public extension MangaDexAPIClient{
    /// Retrieves the author or artist with the given ID.
    ///
    /// - Parameter id: the UUID of the author or artist to fetch.
    ///
    /// - Returns: a `Result` containg the retrieved author or artist or any errors that occured during the get operation.
    ///
    func getAuthor(_ id: UUID) async -> Result<Author, Error> {
        await Task {
            try await self.withRateLimit {
                try await Request<AuthorEntity>(.init(id: id)).execute()
            }
        }.result
    }
    
    /// Retrieves a large amount of authors by making multiple requests, and combining their results.
    ///
    /// - Parameter ids: the UUIDs of the authors or artists to fetch.
    ///
    /// - Returns: a `Result` containing an array of authors or artists, or any  errors that occured during the get operation.
    func getAuthors(_ ids: [UUID]) async -> Result<[Author], Error> {
        guard !ids.isEmpty else {
            return .failure(MangaDexAPIError.badRequest(context: "At least one or more author or artist IDs must be provided."))
        }
        
        let requestsToMake = ids.count > 100 ? (ids.count / 100) + 1 : 1
        
        var result: [Author] = []
        
        for i in 0..<requestsToMake {
            let requestedAuthors = Array(ids[i * 100..<((i + 1) * 100 > ids.count ? ids.count : (i + 1) * 100)])
            do {
                async let (authors, _, _) = self.withRateLimit {
                    try await ListRequest<AuthorListEntity>(.init(
                        ids: requestedAuthors,
                        limit: requestedAuthors.count)
                    ).execute()
                }
                result.append(contentsOf: try await authors)
            } catch let error {
                return .failure(error)
            }
        }
        
        return .success(result)
    }
    
    /// Retrieves the authors or artists with the given IDs.
    ///
    /// - Parameters:
    ///     - ids: the UUIDs of the authors or artists to fetch..
    ///     - limit: the maximum amount of authors or artists to retrieve, up to 100 per request.
    ///     - offset: an amount to shift the retrieved collection's index.
    ///
    /// - Returns: a `Result` containing an array of authors or artists, the total size of the collection, and its offset, or any
    ///            errors that occured during the get operation.
    ///
    func getAuthors(
        _ ids: [UUID],
        limit: Int? = nil,
        offset: Int? = nil
    ) async -> Result<([Author], Int, Int), Error>  {
        guard ids.count > 0 && ids.count <= 100 else {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested authors must be between 1 and 100"))
        }
        
        if let limit = limit, limit < 0 || limit > 100 {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested authors must be between 1 and 100."))
        }
        
        return await Task {
            try await self.withRateLimit {
                try await ListRequest<AuthorListEntity>(.init(
                    ids: ids,
                    limit: limit ?? ids.count,
                    offset: offset ?? 0
                )).execute()
            }
        }.result
    }
}
