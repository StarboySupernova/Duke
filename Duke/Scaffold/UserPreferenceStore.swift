//
//  PreferenceStore.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/13/23.
//

import Foundation
import SwiftUI

//  MARK: DynamicMemberLookup Implementation @dynamicMemberLookup
class UserPreference: ObservableObject {
    //should use MVVM here
    //this class should be the model, with instances of this broadcasting (publishing) user selected data
    //view model will handle storage to UserDefaults
    //use of Dictionary values looking likely, but this will be determined later
    //some properties to be moved to UserPreferenceModel https://paulallies.medium.com/swiftui-mvvm-a1e7a18f4f03
    var id: String = UUID().uuidString //should be set to same as authid from Firebase. Should probably ensure this checks different IDs in UseDefaults and return specific user data for each user
    var halaal: Bool = false
    var haram: Bool = false
    var pork: Bool = false
    var vegan: Bool = false
    var vegetarian: Bool = false
    var lactose: Bool = false
    var outdoor: Bool = false
    var wineTasting: Bool = false
    var wineFarms: Bool = false
    
    ///authentic experiences preferences
    var african: Bool = true
    var italian: Bool = true
    var greek: Bool = true
    var chinese: Bool = true
    var thai: Bool = true
    
    //Add attributed description texts
    //View model will handle saving to keychain
    
    init(isHalaal: Bool = false, haram: Bool = false, pork: Bool = false, vegan: Bool = false,
             vegetarian: Bool = false, lactose: Bool = false, outdoor: Bool = false,
             wineTasting: Bool = false, wineFarms: Bool = false, african: Bool = true,
             italian: Bool = true, greek: Bool = true, chinese: Bool = true, thai: Bool = true) {
            
            self.halaal = isHalaal
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
    
    static let shared = UserPreference()
    
    ///The private initializer private init() ensures that the UserPreference class cannot be instantiated from outside the class. It prevents accidental creation of multiple instances and enforces the use of the shared singleton instance.
    private init() {

    }
    
    /*
    ///subscript may not have been needed to be done in this way. Instead of creating our own Binding retunred from the subscript, we were supposed to pass in a UserPreference object as is to ParallaxView, then hook into the bindings provided by the StateObject on its @Published properties
    ///-- Route taken in this case assumed StateObject values will change in-between ParallaxView swipes offscren, hence the need to create custom subscript returning custom bindings to our properties by string name
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
     */
    
}

extension UserPreference {
    func collectBoolProperties() -> [String] {
        var boolProperties: [String] = []
        
        Mirror(reflecting: self).children.forEach { child in
            if let propertyName = child.label,
               let _ = child.value as? Bool {
                boolProperties.append(propertyName)
            }
        }
        
        return boolProperties
    }
    
    func assignBoolBinding(for propertyToFind: String) -> Binding<Bool> {
        
        let mirror = Mirror(reflecting: self)
        
        guard var target = mirror.children.first(where: {($0.label ?? "") == propertyToFind})?.value as? Bool else {
            fatalError("failed to find specified property on this class") 
        }
        
        return Binding<Bool>(
            get: {
                target
            },
            set: { newValue in target = newValue }
        )
    }
}




