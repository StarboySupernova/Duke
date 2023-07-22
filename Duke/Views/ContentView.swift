//
//  ContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/18/23.
//

import SwiftUI
import BottomSheet

struct ContentView: View {
    @State var currentTab: SideMenuTab = .home
    @State var bottomSheetPosition: BottomSheetPosition = .bottom
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
            //let imageOffset = screenHeight + 36
            
            // NavigationView { //include Navigation when we implement popToRoot functionality
            ZStack {
                TabView(selection: $currentTab) {
                    HomeView()
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
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    CustomTabBar(currentTab: $currentTab) {} //trailing closure execution will depend on which Tab is selected
                    .offset(y: bottomSheetTranslationProrated * 115) //- commenting this out made tab bar stop disappearing offscreen
                }
                .frame(width: geometry.size.width, height: screenHeight) // This ensures the VStack takes the whole screen height
                //.offset(y: bottomSheetTranslationProrated * 115) //offset may need to be placed here, decision inconclusive at this time

                
                BottomSheetView(position: $bottomSheetPosition) {
                    #warning("display a heading here when sheet is activated")
                } content: {
                    //control which view is shown here, depending on the tab button pressed. E.G., if location access is not given or login is incomplete, a View will be shown here
                }
                .onBottomSheetDrag { translation in
                    bottomSheetTranslation = translation / screenHeight
                    
                    withAnimation(.easeInOut) {
                        if bottomSheetPosition == BottomSheetPosition.top {
                            hasDragged = true
                        } else {
                            hasDragged = false
                        }
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
