//
//  VerticalContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 8/14/23.
//

import SwiftUI

struct VerticalContentView: View {
    @Binding var verticalTabSelection: VerticalTab
    @Binding var selectedMenu: SelectedMenu
    
    var body: some View {
        ResponsiveView { prop in
            HStack(spacing: 0) {                
                TabView(selection: $verticalTabSelection) {
                    Text("CHAT")
                        .tag(VerticalTab.chat)
                    
                    Text("Search") //this show home at the top, and will be also available through side menu
                        .tag(VerticalTab.search)
                    
                    Text("Favourites")
                        .tag(VerticalTab.favourites)
                    
                    ProfileView() //this is also availabe through side menu
                        .environmentObject(UserViewModel())
                        .tag(VerticalTab.user)
                }
            }
        }
    }
}

struct VerticalContentView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalContentView(verticalTabSelection: .constant(.chat), selectedMenu: .constant(.home))
    }
}
