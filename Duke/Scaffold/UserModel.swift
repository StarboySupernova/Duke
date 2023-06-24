//
//  UserModel.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 6/24/23.
//

import Foundation

class UserModel: Identifiable {
    
}

struct ParallaxProperties: Identifiable {
    var id = UUID().uuidString
    var headerText: String //should look into making this an attributed string
    var buttonText: [String] //should look into making each element of this array an attributed string
    //no need for button number, as buttons will be generated for each button text
    var imageName: String
}

struct TicketModel: Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
    var subtitle: String
    var top: String
    var bottom: String
}

var tickets: [TicketModel] = [
    TicketModel(image: "thor", title: "Thor", subtitle: "Love and Thunder", top: "thor-top", bottom: "thor-bottom"),
    TicketModel(image: "panther", title: "Black Panther", subtitle: "Wakanda Forever", top: "panther-top", bottom: "panther-bottom"),
    TicketModel(image: "scarlet", title: "Doctor Strange", subtitle: "in the Multiverse of Madness", top: "scarlet-top", bottom: "scarlet-bottom")
]

