//
//  BusinessDetails.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/10/22.
//

import Foundation
import Combine
import CoreLocation


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

struct MapItem: Identifiable {
    let id: UUID = .init()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

extension BusinessDetails {
    var mapItems: [MapItem] {
        if let name = name, let lat = coordinates?.latitude, let long = coordinates?.longitude {
            return [MapItem(name: name, coordinate: .init(latitude: lat, longitude: long))]
        }
        return []
    }
    
    var formattedRating : String {
        String(format: "%.1f", rating ?? 0.0)
    }
    
    var formattedCategory : String {
        categories?.first?.title ?? "none"
    }
    
    var formattedCategories: String {
        categories?
            .lazy
            .compactMap(\.title)
            .reduce("", { $0 + "\($1) • " })
            .dropLast()
            .dropLast()
            .reduce("", { $0 + String($1) })
        ?? "None"
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
    
    // convert day of the week 0-6 monday-sunday to 1-7 sunday - saturday
    var dayOfTheWeek: String {
        let dayOfTheWeek = [0: 2, 1: 3, 2: 4, 3: 5, 4: 6, 5: 7, 6: 1]
        let currentDay = day
        let newDay = dayOfTheWeek[currentDay]
        return hours.flatMap {
            $0.compactMap { $0.hourOpen?.first(where: { $0.day == newDay }) }.first
        }?.getReadableTime ?? "No Time"
    }
    
    // Current day number of the weekday
    var day: Int {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday ?? 0
    }
}

extension Open {
    
    // Military time to hour:min ex: 1000 to 10:00
    var getReadableTime: String {
        guard let start = start, let end = end else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        let startTime = dateFormatter.date(from: start)!
        let endTime = dateFormatter.date(from: end)!
        dateFormatter.dateFormat = "h:mm a"
        return "\(dateFormatter.string(from: startTime)) - \(dateFormatter.string(from: endTime))"
    }
    
}

