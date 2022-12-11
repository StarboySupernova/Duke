//
//  HomeViewModel.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/8/22.
//

import Foundation
import Combine
import MapKit
import ExtensionKit

final class HomeViewModel: ObservableObject {
    @Published var businesses = [Business]()
    @Published var searchText : String
    @Published var selectedCategory: FoodCategory
    @Published var region : MKCoordinateRegion
    @Published var businessDetails : BusinessDetails?
    @Published var status :  CLAuthorizationStatus
    @Published var cityName : String = ""
    
    let manager = CLLocationManager()
    
    init() {
        searchText = ""
        selectedCategory = .all
        region = .init()
        businessDetails = nil //initialized as nil until fetched from API
        status = manager.authorizationStatus
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters //using best accuracy location in computationally expensive and battery intensive
        
        request()
    }
    
    //using methods from ExtensionKit to leverage Combine to provide AuthorizationStatus publisher and avoid implementing a delegate pattern
    func requestPermission() {
        manager
            .requestLocationWhenInUseAuthorization()
            .assign(to: &$status)
    }
    
    func getLocation () -> AnyPublisher<CLLocation, Never> {
        manager.receiveLocationUpdates(oneTime: true) //will run when app launches
            .replaceError(with: [])
            .compactMap(\.first)
            .eraseToAnyPublisher()
    }
    
    func request (service: YelpAPIService = .live) {
        let location = getLocation().share()
        
        //combining search text notifications with notifications from the selected category & location
        $searchText
            .combineLatest($selectedCategory, location)
        //transforming publishers (tuple) into a search request
            .flatMap { (term, category, location) in
                service.request(
                    .search(
                        searchTerm: term,
                        location: location,
                        category: (term.isEmpty || term.isBlank) ? category : nil)) //should try adding or condition for isBlank
            }
            .assign(to: &$businesses)
        
        location
            .flatMap {
                $0.reverseGeocode()
            }
            .compactMap(\.first)
            .compactMap(\.locality)
            .replaceError(with: "Loading...")
            .assign(to: &$cityName)
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
                MKCoordinateRegion(center: coordinates, span: .init(latitudeDelta: 0.001, longitudeDelta: 0.001))
            }
            .assign(to: &$region)
        
        details
            .print()
            .assign(to: &$businessDetails)
    }
}
