//
//  ExtensionOnInteger.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 5/12/22.
//

import Foundation

extension Int :  Identifiable {
    public typealias ID = String
    
    public var id: String{
        return UUID().uuidString
    }
}
