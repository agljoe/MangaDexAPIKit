//
//  MangaDexAPIClient.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// A singleton that makes all requests to the MangaDexAPI.
public actor MangaDexAPIClient: APIClient {
    /// The shared instance of this API client.
    public static let shared = MangaDexAPIClient()
    
   public let rateLimiter: TokenBucket
    
    /// Creates a new `MangaDexAPIClient` whose global rate limit is 5 concurrent requests.
    ///
    /// - Parameter rateLimitter: a token bucket who manages the maximum number of concurrent requests to the MangaDexAPI.
    ///
    /// - Returns: a newly created `MangaDexAPIClient` with the given rate limit.
    private init(rateLimiter: TokenBucket = .init(tokens: 5)) {
        self.rateLimiter = rateLimiter
    }
}
