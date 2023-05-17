//
//  PreferenceStore.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/13/23.
//

import Foundation

class UserPreference: ObservableObject {
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
    
    init(headerText: [String], buttonText: [String], imageName: [String]) {
        self.headerText = headerText
        self.buttonText = buttonText
        self.imageName = imageName
    }
    
    struct PreferencesSelected {
        /// String chosen here over Bool because Firebase seraching might be more complex for true or false values
        /// To display preferred restaurants, we apply filters. Default values indicate that no filters will be applied
        var isHalaal: Bool = false
        var haram: Bool = false
        var pork: Bool = false
        var vegan: Bool = false
        var vegetarian: Bool = false
        var lactose: Bool = false
        var outdoor: Bool = false
        var wineTasting: Bool = false
        var wineFarms: Bool = false
        var authenticRestaurants: AuthenticRestaurant?
        
        struct AuthenticRestaurant {
            var african: (String, Bool) = ("African", true) //when searching Firebase, remember to be case-agnostic
            var italian: (String, Bool) = ("Italian", true)
            var greek: (String, Bool) = ("Greek", true)
            var chinese: (String, Bool) = ("Chinese", true)
            var thai: (String, Bool) = ("Thai", true)
        }
    }
}

