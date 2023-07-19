//
//  ContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/18/23.
//

import SwiftUI

struct ContentView: View {
    @State var currentTab: SideMenuTab = .home
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        // NavigationView { //include Navigation when we implement popToRoot functionality
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(SideMenuTab.home)
                
                Text("Location")
                    .tag(SideMenuTab.task)
                
                SeatsView()
                    .tag(SideMenuTab.documents)
                
                Text("Category")
                    .tag(SideMenuTab.store)
                
                Text("Profile")
                    .tag(SideMenuTab.settings)
            }
            
            CustomTabBar(currentTab: $currentTab) {} //trailing closure execution will depend on which Tab is selected
        }
        .ignoresSafeArea(.keyboard)
        //}
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
