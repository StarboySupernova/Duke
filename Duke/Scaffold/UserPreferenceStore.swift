//
//  PreferenceStore.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/13/23.
//

import Foundation
import SwiftUI

@dynamicMemberLookup
class UserPreference: ObservableObject {
    ///Parallax properties
    var headerText: [String] //should look into making this an attributed string
    var buttonText: [String] //should look into making each element of this array an attributed string
    //no need for button number, as buttons will be generated for each button text
    var imageName: [String]
    
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
    ///subscript may not have been needed to be done in this way. Instead of creating our own Binding retunred from the subscript, we were supposed to pass in a UserPreference object as is to ParallaxView, then hook into the bindings provided by the StateObject on its @Published properties
    ///-- Route taken in this case assumed StateObject values will change in-between PrallaxView swipes offscren, hence the need to create custom subscript returning custom bindings to our properties by string name
    ///--However, this implmentation was needed such that ParaalxView can be able initialize it's buttons based on its buttonText array input and creating bindings to them on the fly
    ///The unintended result of this approach is that we have to explictly initalize the StateObject, which has performance and functionality side-effects we may not anticipate
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

extension UserPreference {
    func collectBoolProperties() -> [String] {
        var boolProperties: [String] = []
        
        Mirror(reflecting: self).children.forEach { child in
            if let propertyName = child.label,
               let _ = child.value as? Published<Bool> {
                boolProperties.append(propertyName)
            }
        }
        
        return boolProperties
    }
}




