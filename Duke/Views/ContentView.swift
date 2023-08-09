//
//  ContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/18/23.
//

import SwiftUI
import BottomSheet


struct ContentView: View {
    @State var currentTab: SideMenuTab = .home //this becomes the property passed into views which will allow me to programmatically change tabs
    @State var bottomSheetPosition: BottomSheetPosition = .bottom
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    @State private var showSideBar: Bool = false


    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        //MARK: Insert functionality to show sidebar on horizontal position / iPad

        ResponsiveView { prop in
            // NavigationView { //include Navigation when we implement popToRoot functionality
            HStack(spacing: 0) {
                //displaying only on iPad and not on split mode
                if prop.isiPad && !prop.isSplit {
                    SideBar(prop: prop, currentTab: $currentTab)
                }
                
                TabView(selection: $currentTab) {
                    HomeView(showSideBar: $showSideBar)
                        .environmentObject(HomeViewModel())
                        .tag(SideMenuTab.home)

                    Text("Location")
                        .tag(SideMenuTab.store)

                    Text("Category")
                        .tag(SideMenuTab.notifications)

                    SeatsView()
                        .tag(SideMenuTab.profile)

                    Text("Profile")
                        .tag(SideMenuTab.settings)
                }
                .ignoresSafeArea(.keyboard)

            }
            .overlay {
                ZStack(alignment: .leading) {
                    Color.black
                        .opacity(showSideBar ? 0.35 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                showSideBar = false //tapping outside SideBar will dismiss the SideBar
                            }
                        }
                    
                    if showSideBar {
                        SideBar(prop: prop, currentTab: $currentTab)
                            .transition(.move(edge: .leading))
                    }
                }
            }

            //}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
