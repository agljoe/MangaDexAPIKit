//
//  Test.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-24.
//

import Foundation
import Testing
@testable import MangaDexAPIKit

fileprivate extension URL {
    /// The query items of a URL is the array of its query parameters. This value
    /// is an empty array if a URL has no query parameters.
    var queryItems: [URLQueryItem] {
       URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems ?? []
    }
}

/// Checks that the limit and offset of a `List` conforming `MangaDexAPIEntity` is equal to the given values.
///
/// - Parameters:
///     - entity: any type that conforms to the `List` protocol.
///     - limit: the expected limit value of the given entity.
///     - offset: the expected offset value of the given entity/
///
/// - Returns: true if the given limit and offset are equal to the entity's, false otherwise.
fileprivate func isExpectedCollectionSize(_ entity: any List, limit: Int, offset: Int) -> Bool {
    entity.limit == limit && entity.offset == offset
}

/// A collection of creational tests for the `AuthorEntity` and `AuthorListEntity` types.
@Suite struct AuthorEntityTests {
    /// Checks that an `AuthorEntity` created with a random UUID has the correct relative path,
    /// and that its reference expansion have been properly initialized.
    ///
    /// The MangaDexAPI specificially needs UUIDs to have thier letters in lowercase, which is
    /// why `uuidString.lowercased()` appears everywhere in this codebase.
    @Test func create() {
        let testId: UUID = UUID()
        let entity = AuthorEntity(id: testId)
        #expect(entity.id == testId)
        #expect(entity.url.relativePath == "/author/\(testId.uuidString.lowercased())")
        #expect(entity.url.queryItems == [URLQueryItem(name: "includes[]", value: "manga")])
    }
    
    /// Checkst that an `AuthorListEntity` initalized with only an array of UUIDs has the correct default limit,
    /// offset, and query parameters.
    @Test func createList() {
        let ids: [UUID] = Array( repeating: UUID(), count: 10)
        let entity = AuthorListEntity(ids: ids)
        
        #expect(entity.ids.count == 10)
        #expect(isExpectedCollectionSize(entity, limit: entity.ids.count, offset: 0))
        
        var parameters: [URLQueryItem] = [URLQueryItem(name: "limit", value: "\(10)"), URLQueryItem(name: "offset", value: "\(0)")]
        parameters.append(contentsOf: ids.map { URLQueryItem(name: "ids[]", value: $0.uuidString.lowercased()) })
        parameters.append(URLQueryItem(name: "order[name]", value: Order.desc.rawValue))
        
        #expect(entity.url.queryItems == parameters)
    }
    
    /// Checks that `AuthorListEntitys` are correctly initalized with various limits and offsets.
    @Test(arguments: zip([10, 20, 50], [0, 10, 20]))
    func createListParamerterized(_ limit: Int, _ offset: Int) {
        let entity = AuthorListEntity(
            ids: Array(repeating: UUID(), count: limit),
            limit: limit,
            offset: offset
        )
        #expect(isExpectedCollectionSize(entity, limit: limit, offset: offset))
    }

}

/// A collection of creational tests for the `ChapterEntity` and `ChapterListEntity` types.
@Suite struct ChapterEntityTests {
    @Test func create() {
        let id = UUID()
        let entity = ChapterEntity(id: id)
        #expect(entity.url.relativePath == "/chapter/\(id.uuidString.lowercased())")
        #expect(entity.url.queryItems == [ChapterReferenceExpansion].all.map{
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        })
    }
    
    @Test func createList() {
        let ids: [UUID] = Array(repeating: UUID(), count: 10)
        let entity = ChapterListEntity.init(ids: ids)
        
        #expect(entity.ids.count == 10)
        #expect(isExpectedCollectionSize(entity, limit: 10, offset: 0))
        
        var parameters: [URLQueryItem] = [URLQueryItem(name: "limit", value: "\(10)"), URLQueryItem(name: "offset", value: "\(0)")]
        parameters.append(contentsOf: ids.map { URLQueryItem(name: "ids[]", value: $0.uuidString.lowercased()) })
        parameters.append(contentsOf: [URLQueryItem(name: "translatedLanguage[]", value: "en"), URLQueryItem(name: "order[name]", value: Order.desc.rawValue)])
        parameters.append(contentsOf: [ChapterReferenceExpansion].all.map { URLQueryItem(name: "includes[]", value: $0.rawValue) })
        
        #expect(entity.url.queryItems == parameters)
    }
}




/// Turns out this doesn't work because passing closures causes a fatal error.
/// If you're interested you can check out the [Swift forurms thread](https://forums.swift.org/t/fatal-error-internal-inconsistency-no-test-reporter-for-test-case-argumentids/75666)
/// that contains other weird Swift testing errors.
//@Suite struct Test {
//    @Test(arguments: [AuthorEntity.init])
//    func create(_ init: (UUID) -> any MangaDexAPIEntity) {
//        
//    }
//}
