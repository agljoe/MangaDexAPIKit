//
//  APIClient.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// A type that interacts with some third party API.
///
/// Clients are responsible for managing any rate limits impossed by a given API.
public protocol APIClient {
    /// The default rate limiter that allows a specified amount of concurrent requests.
    var rateLimiter: TokenBucket { get }
    
    /// Executes a request within the rate limit for this `APIClient`.
    ///
    /// - Parameter body: a closure that requests the specified type `T`
    /// 
    /// - Throws: A `CancellationError` if the request is cancelled while waiting for the rate limiter.
    /// - Throws: Any error thrown by the body closure.
    func withRateLimit<T: Sendable>(_ body: @escaping @Sendable () async throws -> T) async rethrows -> T
}

public extension APIClient {
    func withRateLimit<T: Sendable>(_ body: @escaping @Sendable () async throws -> T) async rethrows -> T {
        try await self.rateLimiter.withToken(body)
    }
}
