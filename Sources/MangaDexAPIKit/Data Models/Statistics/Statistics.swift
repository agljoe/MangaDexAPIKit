//
//  Statistics.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-02-10.
//

import Foundation

/// A type that contains an ID for a comments thread.
public protocol Statistics: Decodable, Equatable, Hashable, Sendable  {
    /// The ID of the comments thread associated with a Manga or Chapter.
    ///
    /// - Note: MangaDex does have general discussion threads, but they are not a part of
    ///         the MangaDexAPI
    var threadId: Int? { get }
}

extension Statistics {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.threadId == rhs.threadId
    }
}

public extension Statistics {
    /// A link to the MangaDexForums thread,, nil if no thread exists.
    var commentsURL: URL? {
        if let id = threadId {
            var components = URLComponents()
            components.host = MangaDexAPIBaseURL.forums.rawValue
            components.path = "\(id)"
            return components.url
        }
        return nil
    }
}

/// Similar to the generic wrapper struct, all JSON data returned from the
/// statistics endpoints have a first key of "statistics".
public struct StatisticsWrapper<T: Statistics>: Decodable {
    /// The Statistics found in this wrapper.
    public let statistics: T
}

/// Similar to the generic wrapper struct, all JSON data returned from the
/// statistics endpoints have a first key of "statistics".
public struct GroupedStatisticsWrapper<T: Statistics>: Decodable {
    /// The grouped Statistics found in this wrapper.
    public let statistics: [String: T]
}
