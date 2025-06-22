//
//  UpdateReadMarkerRequest.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// A request to update the read marker a manga's chapters on MangaDex servers.
struct UpdateReadMarkerRequest {
    /// The markers being updated.
    let markers: ReadMarkerUpdate
    
    /// Creates a new instance with the given values.
    ///
    /// - Parameters:
    ///      - mangaID: the UUID of a manga.
    ///     - chapterIdsRead: the UUID strings of the chapters to mark  "read".
    ///     - chatperIds: the UUID strings of the chapters to mark "unread".
    ///
    /// - Returns: a newly created `UpdateReadMarkerRequest` whose markers have been initalized with the given values.
    init(
        mangaID: UUID,
        chapterIdsRead: [String]? = nil,
        chapterIdsUnread: [String]? = nil
    ) {
        self.markers = .init(
            mangaID: mangaID,
            chapterIdsRead: chapterIdsRead,
            chapterIdsUnread: chapterIdsUnread
        )
    }
    
    /// Creates a new instance with the given values.
    ///
    /// - Parameters:
    ///     - mangaID: the UUID of a manga.
    ///     - chapterIdsRead: the UUIDs of the chapters to mark  "read".
    ///     - chatperIds: the UUIDs of the chapters to mark "unread".
    ///
    /// - Returns: a newly created `UpdateReadMarkerRequest` whose markers have been initalized with the given values.
    init(
        mangaID: UUID,
        chapterIdsRead: [UUID]? = nil,
        chapterIdsUnread: [UUID]? = nil
    ) {
        self.markers = .init(
            mangaID: mangaID,
            chapterIdsRead: chapterIdsRead,
            chapterIdsUnread: chapterIdsUnread
        )
    }
}


extension UpdateReadMarkerRequest: MangaDexAPIRequest {
    typealias ModelType = Response?
    
    func decode(_ data: Data) throws -> Response? {
        fatalError("This function should never be called.")
    }
    
    @discardableResult
    func execute() async throws -> Response? {
        let body = try JSONEncoder().encode(self.markers)
        guard body.count < 10240 && !body.isEmpty else { throw MangaDexAPIError.badRequest(context: "The request body is too large or empty") }
        try await authenticatedPost(at: markers.url)
        return nil
    }
}
