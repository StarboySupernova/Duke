//
//  ExtensionOnEncodable.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 11/10/22.
//

import Foundation

/*extension Encodable {
    var toDictionnary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        var dict : Any? = nil
        var returnDict : [String : Any]? = nil
        do {
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let convertedDict = dict as? [String : Any] {
                returnDict = convertedDict
            } else {
                showErrorAlertView("Error", "Data cast failed") {}
            }
        } catch {
            showErrorAlertView("JSON Serialization failed", error.localizedDescription) {}
        }
        
        return returnDict
        //return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}*/

