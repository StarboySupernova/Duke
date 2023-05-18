//
//  PreferenceStore.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/13/23.
//

import Foundation
import SwiftUI

class UserPreference: ObservableObject {
    ///Parallax properties
    @Published var headerText: [String] //should look into making this an attributed string
    @Published var buttonText: [String] //should look into making each element of this array an attributed string
    //no need for button number, as buttons will be generated for each button text
    @Published var imageName: [String]
    
    ///preferences
    @Published var isHalaal: Bool = false
    @Published var haram: Bool = false
    @Published var pork: Bool = false
    @Published var vegan: Bool = false
    @Published var vegetarian: Bool = false
    @Published var lactose: Bool = false
    @Published var outdoor: Bool = false
    @Published var wineTasting: Bool = false
    @Published var wineFarms: Bool = false
    
    ///authentic experiences preferences
    @Published var african: Bool = true
    @Published var italian: Bool = true
    @Published var greek: Bool = true
    @Published var chinese: Bool = true
    @Published var thai: Bool = true
    
    init(headerText: [String], buttonText: [String], imageName: [String]) {
        self.headerText = headerText
        self.buttonText = buttonText
        self.imageName = imageName
    }
    
    init(headerText: [String] = [], buttonText: [String] = [], imageName: [String] = [],
             isHalaal: Bool = false, haram: Bool = false, pork: Bool = false, vegan: Bool = false,
             vegetarian: Bool = false, lactose: Bool = false, outdoor: Bool = false,
             wineTasting: Bool = false, wineFarms: Bool = false, african: Bool = true,
             italian: Bool = true, greek: Bool = true, chinese: Bool = true, thai: Bool = true) {
            
            self.headerText = headerText
            self.buttonText = buttonText
            self.imageName = imageName
            self.isHalaal = isHalaal
            self.haram = haram
            self.pork = pork
            self.vegan = vegan
            self.vegetarian = vegetarian
            self.lactose = lactose
            self.outdoor = outdoor
            self.wineTasting = wineTasting
            self.wineFarms = wineFarms
            self.african = african
            self.italian = italian
            self.greek = greek
            self.chinese = chinese
            self.thai = thai
        }
    
    subscript(dynamicMember key: String) -> Binding<Bool> {
            Binding<Bool>(
                get: {
                    return self.value(for: key)
                },
                set: { newValue in
                    self.setValue(newValue, for: key)
                }
            )
        }
        
        private func value(for key: String) -> Bool {
            return Mirror(reflecting: self).children
                .compactMap { $0 as? (label: String?, value: Bool) }
                .first { $0.label == key }?.value ?? false
        }
        
        private func setValue(_ newValue: Bool, for key: String) {
            let mirror = Mirror(reflecting: self)
            guard var target = mirror.children
                .first(where: {
                    ($0.label ?? "") == key
                })?.value as? Published<Bool> else {
                return
            }
            
            target = Published<Bool>(wrappedValue: newValue)
        }
    
}



