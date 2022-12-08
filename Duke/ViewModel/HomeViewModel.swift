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
    @Published var searchText : String = ""
    @Published var selectedCategory = FoodCategory.all
    
    func search () {
        let live = YelpAPIService.live
        
        live.search("food", .init(latitude: 42.36, longitude: -71), nil)
            .assign(to: &$businesses)
    }
}
