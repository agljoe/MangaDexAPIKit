//
//  MangaDexAPIClient+UserRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-17.
//

import Foundation


/// User Requests
public extension MangaDexAPIClient {
    /// Retrieves the user wiith the specified UUID.
    ///
    /// - Parameter id: the UUID of the user being retrieved.
    ///
    /// - Returns: a `Result` containing the retrieved user, or any errors that occured during the get operation..
    func getUser(_ id: UUID) async -> Result<User, Error> {
        await Task {
            try await self.withRateLimit {
                try await Request<UserEntity>(.init(id: id)).execute()
            }
        }.result
    }
}
