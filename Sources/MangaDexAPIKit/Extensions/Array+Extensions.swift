//
//  Array+Extensions.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation


extension Array where Element == [String: String]  {
    /// Reduces the weird array of dictionaries returned by the MangaDexAPi into a single dictionary where
    /// each key leads to all available alternate titles for te respective language.
    public func flattenAltTitles() -> [String: [String]] {
        var flattenedDictionary: [String: [String]] = [:]

        for element in self {
            if let _ = flattenedDictionary[element.keys.first!] {
                flattenedDictionary[element.keys.first!]!.append(element.values.first!)
            } else {
                flattenedDictionary.updateValue([element.values.first!], forKey: element.keys.first!)
            }

        }
        
        return flattenedDictionary
    }
}
