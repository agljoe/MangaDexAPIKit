//
//  MangaDexAPIClient+TagRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-17.
//

import Foundation

/// Tag requests.
public extension MangaDexAPIClient {
    /// Retrieves all available tags.
    ///
    /// - Returns: a `Result` containing an array containing the currently available tags,
    ///         or any errors that occured during the get operation.
    func getTags() async -> Result<[Tag], Error> {
        await Task {
            try await self.withRateLimit {
                try await TagListRequest().execute().0
            }
        }.result
    }
}
