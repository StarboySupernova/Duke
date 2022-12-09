//
//  HomeViewModel.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/8/22.
//

import Foundation
import Combine
import MapKit

final class HomeViewModel: ObservableObject {
    @Published var businesses = [Business]()
    @Published var searchText : String
    @Published var selectedCategory: FoodCategory
    @Published var region : MKCoordinateRegion
    @Published var business : Business?
    
    init() {
        searchText = ""
        selectedCategory = .all
        region = .init()
        business = nil //initialized as nil until fetched from API
        
        request()
    }
    
    func request (service: YelpAPIService = .live) {
        //combining search text notifications with notifications from the selected category
        $searchText
            .combineLatest($selectedCategory)
        //transforming htese 2 publishers (tuple) into a search request
            .flatMap { (term, category) in
                service.request(
                    .search(
                        searchTerm: term,
                        location: .init(latitude: 42.3601, longitude: -71.0589),
                        category: (term.isEmpty || term.isBlank) ? category : nil)) //should try adding or condition for isBlank
            }
            .assign(to: &$businesses)
    }
    
    func requestDetails(forID id : String) {
        let live = YelpAPIService.live
        
        let details = live.detailRequest(.detail(id: id))
            .share() //share output with multiple subscribers, i.e. business & region
        
        details
            .compactMap { business in
                CLLocationCoordinate2D(latitude: business?.coordinates?.latitude ?? 0, longitude: business?.coordinates?.longitude ?? 0)
            }
            .compactMap { coordinates in
                MKCoordinateRegion(center: coordinates, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
            .assign(to: &$region)
        
        details
            .assign(to: &$business)
    }
}
