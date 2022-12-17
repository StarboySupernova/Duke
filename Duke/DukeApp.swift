//
//  DukeApp.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/2/22.
//

import SwiftUI

@main
struct DukeApp: App {
    init() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modifier(DarkModeViewModifier())
                .environmentObject(HomeViewModel())
        }
    }
}
