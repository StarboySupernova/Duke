//
//  BusinessDetails.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/10/22.
//

import Foundation


// MARK: - BusinessDetails
struct BusinessDetails: Codable {
    let id, alias, name: String?
    let imageURL: String?
    let isClaimed, isClosed: Bool?
    let url: String?
    let phone, displayPhone: String?
    let reviewCount: Int?
    let categories: [Category]?
    let rating: Double?
    let location: Location?
    let coordinates: Coordinates?
    let photos: [String]?
    let price: String?
    let hours: [Hour]?
    let transactions: [String]?

    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClaimed = "is_claimed"
        case isClosed = "is_closed"
        case url, phone
        case displayPhone = "display_phone"
        case reviewCount = "review_count"
        case categories, rating, location, coordinates, photos, price, hours, transactions
    }
}

// MARK: - Category
struct BusinessCategory: Codable {
    let alias, title: String?
}

// MARK: - Coordinates
struct BusinessCoordinates: Codable {
    let latitude, longitude: Double?
}

// MARK: - Hour
struct Hour: Codable {
    let hourOpen: [Open]?
    let hoursType: String?
    let isOpenNow: Bool?

    enum CodingKeys: String, CodingKey {
        case hourOpen = "open"
        case hoursType = "hours_type"
        case isOpenNow = "is_open_now"
    }
}

// MARK: - Open
struct Open: Codable {
    let isOvernight: Bool?
    let start, end: String?
    let day: Int?

    enum CodingKeys: String, CodingKey {
        case isOvernight = "is_overnight"
        case start, end, day
    }
}

// MARK: - Location
struct BusinessLocation: Codable {
    let address1, address2, address3, city: String?
    let zipCode, country, state: String?
    let displayAddress: [String]?
    let crossStreets: String?

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
        case crossStreets = "cross_streets"
    }
}


extension BusinessDetails {
    var formattedRating : String {
        String(format: "%.1f", rating ?? 0.0)
    }
    
    var formattedCategory : String {
        categories?.first?.title ?? "none"
    }
    
    var formattedName : String {
        name ?? "none"
    }
    
    var formattedPhoneNumber : String {
        displayPhone ?? "none"
    }
    
    var formattedPrice : String {
        price ?? "none"
    }
    
    var formattedAddress : String {
        location?.displayAddress?.first ?? "none"
    }
    
    var images: [URL] {
        photos?.compactMap{ URL.init(string: $0) } ?? []
    }
    
    var formattedImageURL : URL? {
        if let imageURL = imageURL {
            return URL(string: imageURL)
        }
        
        return nil
    }
}

