//
//  AtHomeChapterComponents.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// A group of `URLComponents` used to dynamically construct chapter image URLs.
public struct AtHomeChapterComponents: Decodable, Equatable, Hashable, Sendable {
    /// The base URL for retriving images in this collection.
    ///
    ///  - Important:  Base URLs are valid for 15 minutes. For more information see [MangaDex API Documentation](https://api.mangadex.org/docs/04-chapter/retrieving-chapter/#howto).
    public let baseUrl: String
    
    /// The hash value for this chapter.
    public let hash: String
    
    /// A collection of URL paths to high quality chapter images.
    ///
    /// The index of each element is its page number minus one.
    public let data: [String]
    
    /// A collection of URL paths to low quality chapter images.
    ///
    /// The index of each element is its page number minus one.
    public let dataSaver: [String]
    
    /// The base coding keys for this struct.
    private enum CodingKeys: String, CodingKey {
        case baseUrl, chapter
    }
    
    /// The nested coding keys found through the chapter keypath.
    private enum ChapterCodingKeys: String, CodingKey {
        case hash, data, dataSaver
    }
    
    /// Creates a new `AtHomeChapterComponents` instance with emply values.
    ///
    /// - Returns: the newly created `AtHomeChapterComponents`  initialized with empty values.
    public init() {
        self.baseUrl = ""
        self.hash = ""
        self.data = []
        self.dataSaver = []
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: the newly created `AtHomeChapterComponents`  from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if AtHomeChapterComponents  cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseUrl = try container.decode(String.self, forKey: .baseUrl)
        
        let chapterContainer = try container.nestedContainer(keyedBy: ChapterCodingKeys.self, forKey: .chapter)
        self.hash = try chapterContainer.decode(String.self, forKey: .hash)
        self.data = try chapterContainer.decode([String].self, forKey: .data)
        self.dataSaver = try chapterContainer.decode([String].self, forKey: .dataSaver)
        
    }
    
    /// Returns the complete URL for downloading a chapter image.
    ///
    /// A page's number minus one is equivalent to its index in the 'data' array.
    ///
    /// - Parameter index: the index of a page.
    ///
    /// - Returns: a complete URL that can be used to download a chapter image.
    ///
    /// - Note: Image URLs are constructed using the structure '$.baseUrl / $QUALITY / $.chapter.hash / $.chapter.$QUALITY[*]'
    public subscript(dataIndex index: Int) -> URL {
        return URL(string: "\(baseUrl)/data/\(hash)/\(data[index])")!
    }
    
    /// Returns the complete URL for downloading a lower quality chapter image.
    ///
    /// A page's number minus one is equivalent to its index in the 'dataSaver' array.
    ///
    /// - Parameter index: the index of a page.
    ///
    /// - Returns: a complete URL that can be used to download a chapter image.
    ///
    /// - Note: Image URLs are constructed using the structure '$.baseUrl / $QUALITY / $.chapter.hash / $.chapter.$QUALITY[*]'
    public subscript(dataSaverIndex index: Int) -> URL {
        return URL(string: "\(baseUrl)/data-saver/\(hash)/\(dataSaver[index])")!
    }
}

