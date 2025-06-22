//
//  UpdateMangaReadingStatusRequest.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-05-31.
//

import Foundation

/// Updates a manga's reading status on MangaDex servers.
public struct UpdateMangaReadingStatusRequest {
    /// The reading status update to pass in this request's body.
    fileprivate let status: ReadingStatusUpdate
    
    /// Creates a new instance with the given values.
    ///
    /// - Parameters:
    ///  - id: the UUID of a manga.
    ///  - status: a `ReadingStatus`.
    ///
    /// - Returns: a newly created `UpdateReadingStatusRequest` whose status has bee initalized
    ///            by the given values.
    init(for id: UUID, to status: ReadingStatus) {
        self.status = .init(id: id, status: status)
    }
}

extension UpdateMangaReadingStatusRequest: MangaDexAPIRequest {
    public typealias ModelType = Response
    
    public func decode(_ data: Data) throws -> Response {
        return Response(result: "ok")
    }
    
    public func execute() async throws -> Response {
        let body = try JSONEncoder().encode(status)
        try await authenticatedPost(at: status.url, with: body)
        return try decode(Data())
    }
}
