//
//  SigntureGenerator.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/14/23.
//

import Foundation
import CryptoKit

let pfData: [String: String] = [
    "merchant_id": "10000100",
    "merchant_key": "46f0cd694581a",
    "return_url": "https://www.example.com",
    "notify_url": "https://www.example.com/notify_url",
    "m_payment_id": "UniqueId",
    "amount": "200",
    "item_name": "test product"
]

func generateApiSignature(dataArray: [String: String], passPhrase: String = "") -> String {
    var payload = ""
    
    var sortedData = Array(dataArray.keys).sorted()
    for key in sortedData {
        // Get all the data from Payfast and prepare the parameter string
        if let value = dataArray[key]?.replacingOccurrences(of: "+", with: " ") {
            payload += key + "=" + value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&"
        }
    }
    
    // After looping through, cut the last "&" or append your passphrase
    payload = String(payload.dropLast())
    if !passPhrase.isEmpty {
        payload += passPhrase
    }
    
    let signature = Insecure.MD5.hash(data: Data(payload.utf8)).map { String(format: "%02hhx", $0) }.joined()
    
    return signature
}

let passPhrase = "jt7NOE43FZPn"
let signature = generateApiSignature(dataArray: pfData, passPhrase: passPhrase)


