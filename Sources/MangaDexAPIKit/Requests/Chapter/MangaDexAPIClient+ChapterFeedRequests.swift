//
//  MangaDexAPIClient+ChapterFeedRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// Chapter feed requests.
public extension MangaDexAPIClient {
    /// Retrieves a list of the most recently updated chapters for all manga in the specified MDList.
    ///
    /// - Parameters:
    ///     - id: the UUID  of the MDList to fetch chapters from.
    ///     - limit: the maximum number of chapters to retrieve.
    ///     - offset: an amount to shift the retrieved collection's index.
    ///
    /// - Returns: A `Result` containing an array of chapters, the size of the collection, and its offset,
    ///            or any errors that occured during the get operation..
    func getCustomFeed(
        _ id: UUID,
        limit: Int? = nil,
        offset: Int? = nil
    ) async -> Result<([Chapter], Int, Int), Error> {
        if let limit = limit, limit < 0 || limit > 100 {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested chapters must be between 1 and 100."))
        }
        
       return await Task  {
            try await self.withRateLimit {
                try await ListRequest<CustomFeedEntity>(
                    .init(
                        id: id,
                        limit: limit ?? 100,
                        offset: offset ?? 0
                    )
                ).execute()
            }
        }.result
    }
    
    /// Retrieves a list of the most recently updated chapters for all manga followed by a user.
    ///
    /// - Parameters:
    ///     - limit: the maximum number of chapters to retrieve.
    ///     - offset: an amount to shift the retrieved collection's index.
    ///
    /// - Returns: A `Result` containing an array of chapters, the size of the collection, and its offset,
    ///            or any errors that occured during the get operation.
    func getFollowedFeed(
        limit: Int? = nil,
        offset: Int? = nil
    ) async -> Result<([Chapter], Int, Int), Error> {
        if let limit = limit, limit < 0 || limit > 100 {
            return .failure(MangaDexAPIError.badRequest(context: "The number of requested chapters must be between 1 and 100."))
        }
        
        return await Task {
            try await self.withRateLimit {
                try await ListRequest<FollowedFeedEntity>(
                    .init(
                        limit: limit ?? 100,
                        offset: offset ?? 0
                    )
                ).execute()
            }
        }.result
    }
}
