//
//  HomeViewModel.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/8/22.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var businesses = [Business]()
    @Published var searchText : String
    @Published var selectedCategory: FoodCategory
    
    init() {
        searchText = ""
        selectedCategory = .all
        
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
}
