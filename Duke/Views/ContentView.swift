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
                    .offset(y: bottomSheetTranslationProrated * 115) //- commenting this out made tab bar stop disappearing offscreen
                }
                .ignoresSafeArea(.keyboard)
                
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
    }
}
