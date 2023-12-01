//
//  User.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id : String?
    var userName: String
    var userBio : String 
    var userBioLink: String
    var userUID: String
    var userEmail : String
    //var userProfileURL : URL
    
    enum CodingKeys : CodingKey {
        case id
        case userName
        case userBio
        case userBioLink
        case userUID
        case userEmail
        //case userProfileURL
    }
}
