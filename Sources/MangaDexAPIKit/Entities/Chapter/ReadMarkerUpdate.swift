//
//  ReadMarkerUpdate.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// A group of chapters whose read markers are being updated.
struct ReadMarkerUpdate: Encodable, Sendable {
    /// The UUID of the manga the given chapters belong to.
    let mangaID: UUID
    
    /// The chapters whose marker will be set to read.
    let chapterIdsRead: [String]?
    
    /// The chapters whose marker will be set to unread.
    let chapterIdsUnread: [String]?
    
    /// The possible JSON keys for this type.
    private enum CodingKeys: String, CodingKey {
        case chapterIdsRead, chapterIdsUnread
    }
    
    /// Creates a new `ReadMarkerUpdate` instance for the specified values.
    ///
    /// - Parameters:
    ///  - mangaID: the UUID of the manga whose chapter read markers are being updated.
    ///  - chapterIdsRead: an arrary of chapter UUID strings whose read markers are being set to read.
    ///  - chapterIdsUnread:  an arrary of chapter UUID strings whose read markers are being set to unread.
    ///
    /// - Returns: a newly created `ReadMarkerUpdate` initalized to the given values..
    public init(
        mangaID: UUID,
        chapterIdsRead: [String]? = nil,
        chapterIdsUnread: [String]? = nil
    ) {
        self.mangaID = mangaID
        self.chapterIdsRead = chapterIdsRead
        self.chapterIdsUnread = chapterIdsUnread
    }
    
    /// Creates a new `ReadMarkerUpdate` instance for the specified values.
    ///
    /// - Parameters:
    ///  - mangaID: the UUID of the manga whose chapter read markers are being updated.
    ///  - chapterIdsRead: an arrary of chapter UUIDs whose read markers are being set to read.
    ///  - chapterIdsUnread:  an arrary of chapter UUIDs whose read markers are being set to unread.
    ///
    /// - Returns: a newly created `ReadMarkerUpdate` initalized to the given values..
    public init(
        mangaID: UUID,
        chapterIdsRead: [UUID]? = nil,
        chapterIdsUnread: [UUID]? = nil
    ) {
        self.mangaID = mangaID
        self.chapterIdsRead = chapterIdsRead?.map { $0.uuidString.lowercased() }
        self.chapterIdsUnread = chapterIdsUnread?.map { $0.uuidString.lowercased() }
    }
    
    /// Encodes this value into the given encoder.
    ///
    /// - Parameter encoder: the encoder to write data to.
    ///
    /// - Throws: an `EncodingError` if any values are invalid for the given encoders format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(chapterIdsRead, forKey: .chapterIdsRead)
        try container.encodeIfPresent(chapterIdsUnread, forKey: .chapterIdsUnread)
    }
}

extension ReadMarkerUpdate {
    /// The endpoint used to set the readmarkers for the chatpers of a manga.
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/\(mangaID.uuidString.lowercased())/read"
        //components.queryItems = [URLQueryItem(name: "updateHisttory", value: "\(true)")] -> i think this functionality is not available yet
        return components.url!
    }
}
