//
//  MangaDexAPIClinet+ScanlationGroupRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-17.
//

import Foundation

/// Scanlation group requests.
public extension MangaDexAPIClient {
    /// Retrieves the scanlation group with the specified UUID.
    ///
    /// - Parameter id: the UUID of the scanlation group being retrieved.
    ///
    /// - Returns: a `Result` containing the retrieved scanlation group, or any errors that occured during the get operation.
    func getScanlationGroup(_ id: UUID) async throws -> Result<ScanlationGroup, Error> {
        await Task {
            try await self.withRateLimit {
                try await Request<ScanlationGroupEntity>(.init(id: id)).execute()
            }
        }.result
    }
}
