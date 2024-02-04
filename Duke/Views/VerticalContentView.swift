//
//  VerticalContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 8/14/23.
//

import SwiftUI

struct VerticalContentView: View {
    @Binding var verticalTabSelection: Tab
    @Binding var selectedMenu: SelectedMenu
    @Binding var expandedTrends: Bool
    @Binding var showTrends: Bool
    @State var isOpen = false //maps to showSidebar
    
    @EnvironmentObject var straddleScreen: StraddleScreen //to handle verticalTab view's position onscreen to avoid having it block screen elements
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var preferenceStore: UserPreference
    
    var body: some View {
        ResponsiveView { prop in
            HStack(spacing: 0) {                
                TabView(selection: $verticalTabSelection) {
                    Text("CHAT")
                        .tag(Tab.chat)
                    
                    Text("Search") //this show home at the top, and will be also available through side menu - cannot be done
                        .tag(Tab.search)
                    
                    SelectionView()
                        .tag(Tab.favourites)
                        .environmentObject(preferenceStore)
                    
                    FavouritesContentView()
                        .tag(Tab.user)
                    
                    HomeView(showSideBar: $isOpen, selectedMenu: $selectedMenu, expandedTrends: $expandedTrends, showTrends: $showTrends)
                        .environmentObject(HomeViewModel())
                        .environmentObject(straddleScreen)
                        .environmentObject(UserViewModel())
//                        #("uncomment ths")
//                            .environmentObject(homeVM)
//                            .environmentObject(straddleScreen)
//                            .environmentObject(userVM)
                        .tag(Tab.home)
                }
            }
        }
    }
}

struct VerticalContentView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalContentView(verticalTabSelection: .constant(.user), selectedMenu: .constant(.home), expandedTrends: .constant(false), showTrends: .constant(true))
            .environmentObject(HomeViewModel())
            .environmentObject(StraddleScreen())
            .environmentObject(UserViewModel())
            .environmentObject(UserPreference())
    }
}
