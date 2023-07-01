//
//  UserModel.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 6/24/23.
//

import Foundation

struct ParallaxProperties: Identifiable, Hashable {
    var id = UUID().uuidString
    var headerText: String //should look into making this an attributed string
    var buttonText: [String] //should look into making each element of this array an attributed string
    //no need for button number, as buttons will be generated for each button text
    var imageName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ParallaxProperties, rhs: ParallaxProperties) -> Bool {
        return lhs.id == rhs.id
    }
}


