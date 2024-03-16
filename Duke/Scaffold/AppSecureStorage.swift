//
//  AppSecureStorage.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 3/16/24.
//

import SwiftUI

@propertyWrapper
public struct AppSecureStorage: DynamicProperty {
    private let key: String
    private let accessibility:KeychainItemAccessibility

    public var wrappedValue: String? {
        get {
            KeychainWrapper.standard.string(forKey: key, withAccessibility: self.accessibility)
        }

        nonmutating set {
            if let newValue, !newValue.isEmpty  {
                KeychainWrapper.standard.set( newValue, forKey: key, withAccessibility: self.accessibility)
            }
            else {
                KeychainWrapper.standard.removeObject(forKey: key, withAccessibility: self.accessibility)
            }
        }
    }
        
      /// Binding compliant
//    public var projectedValue: Binding<String> {
//        Binding(
//            get: { wrappedValue ?? "" },
//            set: { wrappedValue = $0 }
//        )
//    }
    public init(_ key: String, accessibility:KeychainItemAccessibility =  .whenUnlocked ) {
        self.key = key
        self.accessibility = accessibility
    }
}
