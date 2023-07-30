//
//  ExtensionOnUIApplication.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/30/23.
//

import Foundation
import SwiftUI
import UIKit

extension UIApplication {
    var iosVersion: Int {
        let version = UIDevice.current.systemVersion
        return Int(version.prefix(2)) ?? 0
    }
}
