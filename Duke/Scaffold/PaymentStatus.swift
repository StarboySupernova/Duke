//
//  PaymentStatus.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/21/23.
//

import Foundation

enum PaymentStatus: String, CaseIterable {
case started = "Connected..."
case initiated = "Secure Payment..."
case finished = "Purchased"
    
    var symbolImage : String {
        switch self {
        case .started :
           return "wifi"
        case .initiated :
           return "checkmark.shield"
        case .finished :
           return "checkmark"
        }
    }
}
