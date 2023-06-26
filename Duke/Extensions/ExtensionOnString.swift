//
//  ExtensionOnString.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 4/20/22.
//

import Foundation

//String conformance to identifiable
extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

//to be able to throw strings as errors
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
