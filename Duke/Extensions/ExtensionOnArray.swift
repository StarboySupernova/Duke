//
//  ExtensionOnArray.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 5/12/22.
//

import Foundation

extension Array: Identifiable where Element: Identifiable {
    public var id: String {
        UUID().uuidString
    }
}
