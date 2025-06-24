//
//  ReadingStatusUpdateEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// Represents the required data for the body of a request to set a manga's reading status.
struct ReadingStatusUpdate: Encodable {
    /// The UUID of the manga to update.
    let id: UUID
    
    /// The reading status to set.
    let status: String?
    
    /// Creates a new instance with the given values.
    ///
    /// - Parameters:
    ///     - id: the UUID of a manga.
    ///     - status: a `ReadingStatus`.
    ///
    ///  - Returns: a newly created `ReadingStatusUpdate` for the given manga.
    init(
        id: UUID,
        status: ReadingStatus
    ) {
        self.id = id
        switch status {
        case .none: self.status = nil
        default : self.status = status.rawValue
        }
    }
    
    /// Encodes a single value with the given encoder.
    ///
    /// - Parameter encoder: the encoder to encode with.
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(status)
    }
}

extension ReadingStatusUpdate {
    /// The endpoint for updating a manga's reading status.
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/\(id.uuidString.lowercased())/status"
        return components.url!
    }
}
