//
//  Completions.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/12/22.
//

import Foundation

// MARK: - Categories
struct Completions: Codable {
    let categories: [Category]?
    let businesses: [Business]?
    let terms: [Term]
}

// MARK: - Term
struct Term: Codable {
    let text: String
}

