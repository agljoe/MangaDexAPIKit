//
//  ChapterStatistics.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// A collection of statistics for a given chapter.
///
/// ### See
/// [MangaDex API Documentation](https://api.mangadex.org/docs/redoc.html#tag/Statistics/operation/get-statistics-chapter-uuid)
public struct ChapterStatistics: Statistics {
    /// The id of the comments thread for a specific chapter.
    public let threadId: Int?
    
    /// The total number of comments in a specific chapter's comments thread.
    public  let repliesCount: Int?
    
    /// Used to get the chapter UUID which is the first key in the returned JSON data.
    private struct DynamicCodingKeys: CodingKey {
        /// The string value of this dynamic key.
        var stringValue: String
        
        /// Creates the string value for this key if possible.
        ///
        /// - Parameter stringValue: The string this key is initialized to.
        ///
        /// - Returns: a newly created string coding key.
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        /// The integer value of this dynamic key.
        var intValue: Int?
        
        /// Creates the integer value for this key if possible.
        ///
        /// - Parameter intValue: The integer this key is initialized to.
        ///
        /// - Returns: a newly created integer coding key.
        init?(intValue: Int) {
            return nil
        }
    }

    /// The base coding keys for this struct.
    private enum CodingKeys: CodingKey {
        case comments
    }
    
    /// The nested coding keys found through the comments keypath.
    private enum CommentsCodingKeys: CodingKey {
        case threadId, repliesCount
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created ChapterStatisics from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a ChapterStatistics cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        if let container = try? dynamicContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .init(stringValue: dynamicContainer.allKeys.first!.stringValue)!) {
            if let commentsContainer = try? container.nestedContainer(keyedBy: CommentsCodingKeys.self, forKey: .comments) {
                self.threadId = try commentsContainer.decodeIfPresent(Int.self, forKey: .threadId)
                self.repliesCount = try commentsContainer.decodeIfPresent(Int.self, forKey: .repliesCount)
            } else {
                self.threadId = nil
                self.repliesCount = nil
            }
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let commentsContainer = try? container.nestedContainer(keyedBy: CommentsCodingKeys.self, forKey: .comments) {
                self.threadId = try commentsContainer.decodeIfPresent(Int.self, forKey: .threadId)
                self.repliesCount = try commentsContainer.decodeIfPresent(Int.self, forKey: .repliesCount)
            } else {
                self.threadId = nil
                self.repliesCount = nil
            }
        }
    }
}
