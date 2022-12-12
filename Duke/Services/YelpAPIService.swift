//
//  YelpAPIService.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/6/22.
//

import Foundation
import CoreLocation
import Combine

//should obfuscate this for security reasons
let apiKey = "z-AJB5EZCHE6wvjrr7oC0FJGAX7mnct7bbN73okK0iedlC5k0dWSLDOnI_zd8LRxeqsfS2JRhd6C9hAhzdq_Na9Va1342NisSGba25m4iDhl0Acn4kOMkO2iktKLY3Yx"

struct YelpAPIService {
    //Search endpoints
    //Passed in inputs, such as typing in the search bar, user's location, or user's category
    //category optional to handle when the "All" category is selected
    //AnyPublisher is output leveraged to update ListView
    var request : (EndPoint) -> AnyPublisher<[Business], Never>
    var detailRequest : (EndPoint) -> AnyPublisher<BusinessDetails?, Never>
    var completion : (EndPoint) -> AnyPublisher<[Term], Never>
}

extension YelpAPIService {
    static let live = YelpAPIService (request: { endpoint in
        //URL request and return  [Businesses]
        return URLSession.shared.dataTaskPublisher(for: endpoint.request)
            .map(\.data) //should find a way to use response here for error handling
            .decode(type: SearchResult.self, decoder: JSONDecoder())
            .map(\.businesses)
            .replaceError(with: []) //replace error with empty array
            .receive(on: DispatchQueue.main) //iffy here, may freeze up app UI if this takes too long
            .eraseToAnyPublisher()
    }, detailRequest: { endpoint in
        //URL request and return Business
        return URLSession.shared.dataTaskPublisher(for: endpoint.request)
            .map(\.data) //should find a way to use response here for error handling
            .decode(type: BusinessDetails?.self, decoder: JSONDecoder())
            .replaceError(with: nil) //we might possibly get nil result
            .receive(on: DispatchQueue.main) //iffy here, may freeze up app UI if this takes too long
            .eraseToAnyPublisher()
    }) { endpoint in
        //URL request and return completions
        return URLSession.shared.dataTaskPublisher(for: endpoint.request)
            .map(\.data) //should find a way to use response here for error handling
            .decode(type: Completions.self, decoder: JSONDecoder())
            .map(\.terms)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main) //iffy here, may freeze up app UI if this takes too long
            .eraseToAnyPublisher()
    }
}

//should refactor and move into seperate files
enum EndPoint {
    case search(searchTerm: String?, location: CLLocation, category: FoodCategory?)
    case detail(id: String)
    case completion(text: String, location : CLLocation)
    
    var path: String {
        switch self {
        case .search:
            return "/v3/businesses/search"
        case .detail(let id):
            return "/v3/businesses/\(id)"
        case .completion :
            return "/v3/autocomplete"
        }
    }
    
    var queryItems : [URLQueryItem] {
        switch self {
        case .search(let searchTerm, let location, let category):
            //parameters we need to be passed in, that can be passed, as per Yelp Fusion API docs
            //will be appended to app-internally constructed url
            return [
                .init(name: "term", value: searchTerm),
                .init(name: "longitude", value: String(location.coordinate.longitude)),
                .init(name: "latitude", value: String(location.coordinate.latitude)),
                .init(name: "category", value: category?.rawValue ?? FoodCategory.all.rawValue)
            ]
        case .detail:
            //returning empty array here because all that's required is the id
            return []
        case .completion(let text, let location) :
            return [
                .init(name: "text", value: text),
                .init(name: "longitude", value: String(location.coordinate.longitude)),
                .init(name: "latitude", value: String(location.coordinate.latitude)),
            ]
        }
    }
    
    var request : URLRequest {
        //URL component for Yelp endpoint
        //constructing URLs from their constituent paths
        var urlComponents = URLComponents(string: "https://api.yelp.com")!
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        //app-internally constructed url
        let url = urlComponents.url!
        
        //adding authorization header to url request, as per Yelp Fusion API docs
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}

//MARK: - SearchResult
//modeled after sample response from Yelp Fusion API docs

struct SearchResult: Codable {
    let businesses : [Business]
}

// MARK: - Business
struct Business: Codable {
    let alias: String?
    let categories: [Category]?
    let coordinates: Coordinates?
    let displayPhone: String?
    let distance: Double?
    let id: String?
    let imageURL: String?
    let isClosed: Bool?
    let location: Location?
    let name, phone, price: String?
    let rating, reviewCount: Double?
    let transactions: [String]?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case alias, categories, coordinates
        case displayPhone = "display_phone"
        case distance, id
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case location, name, phone, price, rating
        case reviewCount = "review_count"
        case transactions, url
    }
}

extension Business {
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
    
    var formattedImageURL : URL? {
        if let imageURL = imageURL {
            return URL(string: imageURL)
        }
        
        return nil
    }
    
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String?
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: Double?
}

// MARK: - Location
struct Location: Codable {
    let address1, address2, address3, city: String?
    let country: String?
    let displayAddress: [String]?
    let state, zipCode: String?
    
    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city, country
        case displayAddress = "display_address"
        case state
        case zipCode = "zip_code"
    }
}

