//
//  LandingView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 4/26/23.
//

import SwiftUI

struct LandingView: View {
    @State var currentTab: Tab = .home
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(Tab.home)
                
                /*
                Text("Location")
                    .tag(Tab.location)
                
                Text("Category")
                    .tag(Tab.category)
                
                Text("Profile")
                    .tag(Tab.profile)
                 */
            }
            
            CustomTabBar(currentTab: $currentTab, action: {})
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
