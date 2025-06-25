//
//  TokenBucket.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import DequeModule
import Foundation

/// A rate limiter that ensures the number of requests made by the `MangaDexAPIRequestManger` does not exceed the specified rate limits.
///
/// This implementation is provided by the [swift-package-manager](https://github.com/swiftlang/swift-package-manager/blob/main/Sources/Basics/Concurrency/TokenBucket.swift).
///
/// ### See
/// [Limitations and Requirements](https://api.mangadex.org/docs/2-limitations/)
public actor TokenBucket: Sendable {
    /// The maximum number of concurrent requests.
    private var tokens: Int
    
    /// A two ended queue of requests waiting to be executed.
    private var waiters: Deque<CheckedContinuation<Void, Never>>
    
    /// Creates a new `TokenBucket` with the given number of tokens.
    ///
    /// - Parameter tokens: the maximum number of concurrent requests allowed by this token bucket.
    ///
    /// - Returns: a newly created `TokenBucket` initialized with a maximum capacity of the given tokens.
    public init(tokens: Int) {
        self.tokens = tokens
        self.waiters = Deque()
    }
    
    /// Takes one token out of the bucket if any are available, otherwise waits for an available token.
    private func getToken() async {
        if self.tokens > 0 {
            self.tokens -= 1
            return
        }
        
        await withCheckedContinuation { self.waiters.append($0) }
    }
    
    /// Returns a token to be bucket, and wakes up the waiter who is first in the queue.
    private func returnToken() {
        if let nextWaiter = self.waiters.popFirst() {
            nextWaiter.resume()
        } else {
            self.tokens += 1
        }
    }
    
    /// Performs some asynchronous work as soon as a token is available, if there is none execution is suspended until there is one.
    ///
    /// To enforce the global rate limit of approximately 5 requests a second this function delays the execute of its work for a fifth of a second.
    ///
    /// - Parameter body: a closure that is invoked when a token is available.
    ///
    /// - Returns: the result of the body closure.
    public func withToken<T: Sendable>(_ body: @Sendable () async throws -> T) async rethrows -> T {
        Task { try await Task.sleep(for: .milliseconds(200)) }
        await self.getToken()
        defer { self.returnToken() }
        return try await body()
    }
}

