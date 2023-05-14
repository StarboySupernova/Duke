//
//  PreferenceStore.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/13/23.
//

import Foundation

class Preference: ObservableObject {
    @Published var headerText: [String] //should look into making this an attributed string
    @Published var buttonText: [String] //should look into making each element of this array an attributed string
    //no need for button number, as buttons will be generated for each button text
    @Published var imageName: [String]
    @Published var selected: PreferencesSelected = PreferencesSelected() // set to default values
    
    init(headerText: [String], buttonText: [String], imageName: [String], selected: PreferencesSelected) {
        self.headerText = headerText
        self.buttonText = buttonText
        self.imageName = imageName
        self.selected = selected
    }
    
    struct PreferencesSelected {
        /// String chosen here over Bool because Firebase seraching might be more complex for true or false values
        /// To display preferred restaurants, we apply filters. Default values indicate that no filters will be applied
        var isHalaal: String = "NO"
        var haram: String = "NO"
        var pork: String = "NO"
        var vegan: String = "NO"
        var vegetarian: String = "NO"
        var lactose: String = "NO"
        var outdoor: String = "NO"
        var wineTasting: String = "NO"
        var wineFarms: String = "NO"
        var authenticRestaurants: AuthenticRestaurant?
        
        struct AuthenticRestaurant {
            var african: (String, String) = ("African", "NO") //when searching Firebase, remember to be case-agnostic
            var italian: (String, String) = ("Italian", "NO")
            var greek: (String, String) = ("Greek", "NO")
            var chinese: (String, String) = ("Chinese", "NO")
            var thai: (String, String) = ("Thai", "NO")
        }
    }
}

class PreferenceStore: ObservableObject {
    @Published var preference : Preference?
}
