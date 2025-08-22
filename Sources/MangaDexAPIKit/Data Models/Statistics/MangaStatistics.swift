//
//  MangaStatistics.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// A collection of statistics for a given manga.
///
/// In addition to a thread ID, a manga's statistics contains its rating, and follows count. MangaDex provides the unweighted average, and weighted bayesian average.
/// To calculate other statisics you can use the provided ``MangaStatistics/distribution`` dictionary.
///
/// ### See
/// [MangaDex API Documentation](https://api.mangadex.org/docs/redoc.html#tag/Statistics/operation/get-statistics-manga-uuid)
///
/// [Bayesian Ratings](https://api.mangadex.org/docs/03-manga/statistics/)
public struct MangaStatistics: Statistics {
    /// The id of the comments thread for a  specificmanga.
    public let threadId: Int?
    
    /// The total number of replies in a specific manga's comments thread.
    public let repliesCount: Int?
    
    /// The true mean of a specific manga's rating scores.
    ///
    /// Manga are scored on a scale of 1 to 10 stars inclusive.
    public let average: Double?
    
    /// The bayesian weighted average of a specific manga's rating scores.
    public let bayesian: Double?
    
    /// The distribution of a manga's rating scores.
    public let distribution: [String: Int]?
    
    /// The total number of users who follow a specific manga.
    public let follows: Int
    
    /// Used to get the manga UUID which is the first key in the returned JSON data.
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
      case comments, rating, follows
    }
    
    /// The nested coding keys found through the comments keypath.
    private enum CommentsCodingKeys: CodingKey {
        case threadId, repliesCount
    }
    
    /// The nested coding keys found through the rating keypath.
    private enum RatingCodingKeys: CodingKey {
        case average, bayesian, distribution
    }
    
    private init(
        threadID: Int?,
        repliesCount: Int?,
        average: Double?,
        bayesian: Double?,
        distribution: [String: Int]?,
        follows: Int
    ) {
        self.threadId = threadID
        self.repliesCount = repliesCount
        self.average = average
        self.bayesian = bayesian
        self.distribution = distribution
        self.follows = follows
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created MangaStatistics from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a MangaStatistics cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let dynamicConatiner = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let firstKey: DynamicCodingKeys = .init(stringValue: dynamicConatiner.allKeys.first!.stringValue) ?? .init(intValue: 0)!
        
        if let _ = UUID(uuidString: firstKey.stringValue) {
            let container = try dynamicConatiner.nestedContainer(keyedBy: CodingKeys.self, forKey: firstKey)
            if  let commentsContainer = try? container.nestedContainer(keyedBy: CommentsCodingKeys.self, forKey: .comments) {
                self.threadId = try commentsContainer.decodeIfPresent(Int.self, forKey: .threadId)
                self.repliesCount = try commentsContainer.decodeIfPresent(Int.self, forKey: .repliesCount)
            } else {
                self.threadId = nil
                self.repliesCount = nil
            }
            
            let ratingContainer = try container.nestedContainer(keyedBy: RatingCodingKeys.self, forKey: .rating)
            self.average = try ratingContainer.decodeIfPresent(Double.self, forKey: .average)
            self.bayesian = try ratingContainer.decode(Double.self, forKey: .bayesian)
            self.distribution = try ratingContainer.decodeIfPresent([String: Int].self, forKey: .distribution)
            
            self.follows = try container.decode(Int.self, forKey: .follows)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.follows = try container.decode(Int.self, forKey: .follows)
            
            let ratingContainer = try container.nestedContainer(keyedBy: RatingCodingKeys.self, forKey: .rating)
            self.average = try ratingContainer.decodeIfPresent(Double.self, forKey: .average)
            self.bayesian = try ratingContainer.decodeIfPresent(Double.self, forKey: .bayesian)
            self.distribution = try ratingContainer.decodeIfPresent([String: Int].self, forKey: .distribution)
            
            if let commentsContainer = try? container.nestedContainer(keyedBy: CommentsCodingKeys.self, forKey: .comments) {
                self.threadId = try commentsContainer.decodeIfPresent(Int.self, forKey: .threadId)
                self.repliesCount = try commentsContainer.decodeIfPresent(Int.self, forKey: .repliesCount)
            } else {
                self.threadId = nil
                self.repliesCount = nil
            }
        }
    }
    
    /// The total number of ratings for a given manga.
    ///
    /// - Returns: the sum of the values of the `distribution` dictionary.
    public func totalRatings() -> Int {
        guard let distribution else { return 0 }
        return distribution.values.reduce(0, +)
    }
}

public extension MangaStatistics {
    /// Creates a new `MangaStatistics` instance.
    ///
    /// - Returns: a newly created `MangaStatistics` intialized with placeholder values.
    init() {
        self.init(
            threadID: nil,
            repliesCount: nil,
            average: nil,
            bayesian: nil,
            distribution: [:],
            follows: 0
        )
    }
}
