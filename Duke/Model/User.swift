//
//  User.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import Foundation
import FirebaseFirestoreSwift

struct InternalUser: Identifiable, Codable {
    @DocumentID var id : String?
    var userName: String
    var userBio : String //substitution for userBio
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
