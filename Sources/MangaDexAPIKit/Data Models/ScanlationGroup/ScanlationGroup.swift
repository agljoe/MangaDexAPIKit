//
//  ScanlationGroup.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2024-08-25.
//

import Foundation

/// A group of people who translate manga.
///
/// ### See
/// [MangaDex API Documentation](https://api.mangadex.org/docs/redoc.html#tag/ScanlationGroup/operation/get-group-id)
public struct ScanlationGroup: Identifiable, Equatable, Hashable, Decodable, Sendable {
    /// A unique id assigned to a scanlation group.
    public let id: UUID
    
    /// The name of a scanlation group.
    public let name: String
    
    /// A link to the official website of a scanlation group.
    public let website: String?
    
    /// A link to the internet relay chat server of a scanlation group.
    public let ircServer: String?
    
    /// A link to an internet relay chat channel of a scanlation group.
    public let ircChannel: String?
    
    /// A link to the Discord server of a scanlation group.
    public let discord: String?
    
    /// The email adress of a scanlation group.
    public let contactEmail: String?
    
    /// The description of a scanlation group.
    public let description: String?
    
    /// A link to the Twitter page of a scanlation group.
    public let twitter: String?
    
    /// A link to the Manga Updates page of a scanlation group.
    public let mangaUpdates: String?
    
    /// A collection of languages a scanlation group translates for.
    public let focusedLanguages: [String]?
    
    /// Whether or not a scanlation group is locked.
    public let locked: Bool
    
    /// Whether or not a scanlation group is an official source.
    public let official: Bool
    
    /// Whether or not a scanlation group is verified by MangaDex.
    public  let verified: Bool
    
    /// Whether or not a scanlation group is active.
    public let inactive: Bool
    
    /// Whether or not a scanlation group is exclusively licensed.
    public let exLicensed: Bool?
    
    /// The publish delay of chapters translated by a scanlation group.
    public let publishDelay: String?
    
    /// The date this scanlation group was created.
    public let createdAt: Date
    
    /// The date this scanlation group was last modified.
    public let updatedAt: Date
    
    /// The number of times this scanlation group has been updated.
    public let version: Int
    
    /// A collection of users in a scanlation group.
    public let relationships: [User]?
    
    /// The base coding keys for this struct.
    private enum CodingKeys: CodingKey {
        case id, name, attributes, relationships
    }
    
    /// The nested coding keys found through the attributes keypath.
    private enum AttributeCodingKeys: CodingKey {
        case name, locked, website, ircServer, ircChannel, discord, contactEmail, description, twitter, mangaUpdates, focusedLanguages, official, verified, inactive, exLisensed, publishDelay, createdAt, updatedAt, version
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created ScanlationGroup from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a ScanlationGroup cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        
        let attributesContainer = try container.nestedContainer(keyedBy: AttributeCodingKeys.self, forKey: .attributes)
        self.name = try attributesContainer.decode(String.self, forKey: .name)
        self.locked = try attributesContainer.decode(Bool.self, forKey: .locked)
        self.website = try attributesContainer.decodeIfPresent(String.self, forKey: .website)
        self.ircServer = try attributesContainer.decodeIfPresent(String.self, forKey: .ircServer)
        self.ircChannel = try attributesContainer.decodeIfPresent(String.self, forKey: .ircChannel)
        self.discord = try attributesContainer.decodeIfPresent(String.self, forKey: .discord)
        self.contactEmail = try attributesContainer.decodeIfPresent(String.self, forKey: .contactEmail)
        self.description = try attributesContainer.decodeIfPresent(String.self, forKey: .description)
        self.twitter = try attributesContainer.decodeIfPresent(String.self, forKey: .twitter)
        self.mangaUpdates = try attributesContainer.decodeIfPresent(String.self, forKey: .mangaUpdates)
        self.focusedLanguages = try attributesContainer.decodeIfPresent([String].self, forKey: .focusedLanguages)
        self.official = try attributesContainer.decode(Bool.self, forKey: .official)
        self.verified = try attributesContainer.decode(Bool.self, forKey: .verified)
        self.inactive = try attributesContainer.decode(Bool.self, forKey: .inactive)
        self.exLicensed = try attributesContainer.decodeIfPresent(Bool.self, forKey: .exLisensed)
        self.publishDelay = try attributesContainer.decodeIfPresent(String.self, forKey: .publishDelay)
        self.createdAt = try attributesContainer.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try attributesContainer.decode(Date.self, forKey: .updatedAt)
        self.version = try attributesContainer.decode(Int.self, forKey: .version)
        
        self.relationships = try container.decodeIfPresent([User].self, forKey: .relationships)
    }
    
    public static func == (lhs: ScanlationGroup, rhs: ScanlationGroup) -> Bool {
        return lhs.id == rhs.id && lhs.updatedAt == rhs.updatedAt
    }
}

