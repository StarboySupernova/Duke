//
//  ExtensionOnUserDefaults.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 11/8/22.
//

import Foundation

//no longer using this because
/*
 It's better to only remove those keys you know and which are "yours". Deleting every key explicitly may cause undesired side effects. Some keys may not even be removable at all, since there origin is a read-only plist somewhere in the file system, or "managed app configurations"
 */

extension UserDefaults {
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        } else {
            showErrorAlertView("Error", "Bundle ID incorrect") {}
        }
    }
}

