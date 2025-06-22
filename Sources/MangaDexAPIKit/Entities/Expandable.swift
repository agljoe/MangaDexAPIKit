//
//  Expandable.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// A `ReferenceExpansion` is best represented as a case which indicates an additional type or
/// types will be returned when requesting a specific entity.
public protocol ReferenceExpansion: RawRepresentable, CaseIterable, Sendable { }

/// Expandable types have available references that can be expanded.
public protocol Expandable {
    /// The actual type of a reference expansion conforming type.
    associatedtype Reference: ReferenceExpansion
    
    /// The references to expand for a given request.
    var expansions: [Reference] { get }
}
