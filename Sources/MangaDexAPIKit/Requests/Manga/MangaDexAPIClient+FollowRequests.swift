//
//  MangaDexAPIClient+FollowRequests.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-17.
//

import Foundation

/// Follow requests
public extension MangaDexAPIClient {
    /// Determines if a user if following a given manga.
    ///
    /// - Parameter id: the UUID of manga.
    ///
    /// - Returns: a `Result` indicating if the specified manga is followed,
    ///            or any errors that occured during the get operation.
    func checkIfMangaIsFollowed(_ id: UUID) async -> Result<Bool, Error> {
        await Task {
            try await self.withRateLimit {
                try await CheckIfMangaIsFollowedRequest(id: id).execute()
            }
        }.result
    }
    
    /// Adds the specified manga's chapters to a user's followed feed.
    ///
    /// - Parameter id: the UUID of the manga to follow.
    ///
    /// - Returns: a `Result` indicating if the specified manga was successfully followed,
    ///            or any errors that occured during the post operation.
    @discardableResult
    func follow(manga id: UUID) async -> Result<Response, Error> {
        await Task {
            try await self.withRateLimit {
                try await Follow(manga: id).execute()
            }
        }.result
    }
    
    /// Removes the specified manga's chapters to a user's followed feed.
    ///
    /// - Parameter id: the UUID of the manga to unfollow.
    ///
    /// - Returns: a `Result` indicating if the specified manga was successfully unfollowed,
    ///            or any errors that occured during the delete operation.
    @discardableResult
    func unfollow(manga id: UUID) async -> Result<Response, Error> {
        await Task {
            try await self.withRateLimit {
                try await  Unfollow(manga: id).execute()
            }
        }.result
    }
}
