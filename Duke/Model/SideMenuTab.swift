//
//  SideMenuTab.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/15/23.
//

import Foundation

//Tab enum model, raw value is image file name in assets
enum SideMenuTab: String, CaseIterable {
    case home = "Home"
    case dashboard = "Dashboard"
    case transaction = "Transaction"
    case task = "Task"
    case documents = "Documents"
    case store  = "Store"
    case notifications = "Notifications"
    case profile = "Profile"
    case settings = "Settings"
}
