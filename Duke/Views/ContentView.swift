//
//  ContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/18/23.
//

import SwiftUI


struct ContentView: View {
    @State var currentTab: SideMenuTab = .home //this becomes the property passed into views which will allow me to programmatically change tabs
    @State var bottomSheetPosition: BottomSheetPosition = .bottom
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    @State var isOpen = false //maps to showSidebar


    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        //MARK: Insert functionality to show sidebar on horizontal position / iPad
        ZStack {
            Color(hex: "17203A").ignoresSafeArea()

            ResponsiveView { prop in
                // NavigationView { //include Navigation when we implement popToRoot functionality
                HStack(spacing: 0) {
                    //displaying only on iPad and not on split mode
                    if prop.isiPad && !prop.isSplit {
                        SideBar(prop: prop, currentTab: $currentTab)
                    }
                    
                    TabView(selection: $currentTab) {
                        HomeView(showSideBar: $isOpen)
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
                            .opacity(isOpen ? 0.35 : 0)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    isOpen = false //tapping outside SideBar will dismiss the SideBar
                                }
                            }
                        
                        if isOpen {
                            SideBar(prop: prop, currentTab: $currentTab)
                                .transition(.move(edge: .leading))
                        }
                    }
                }

                //}
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
