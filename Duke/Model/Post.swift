//
//  Post.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import Foundation
import FirebaseFirestoreSwift

struct InternalPost: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var text: String
    var imageURL: URL?
    var imageReferenceID: String = "" //used for deletions
    var publishedDate : Date = Date()
    var upvoteIDs:[String] = []
    var downvoteIDs: [String] = []
    //Post Author details
    var userName: String
    var userUID: String
    //var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case imageURL
        case imageReferenceID //used for deletions
        case publishedDate
        case upvoteIDs
        case downvoteIDs
        case userName
        case userUID
        //case userProfileURL
    }
}
