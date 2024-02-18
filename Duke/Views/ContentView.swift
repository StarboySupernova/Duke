//
//  ContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/18/23.
//

import SwiftUI
import RiveRuntime


struct ContentView: View {
    @AppStorage("selectedMenu") var selectedMenu: SelectedMenu = .home //this becomes the property passed into views which will allow me to programmatically change tabs
    @AppStorage("tabSelection") var tabSelection: Tab = .chat
    @EnvironmentObject var straddleScreen: StraddleScreen //to handle verticalTab view's position onscreen to avoid having it block screen elements 12/11/23 will now also handle menu button's position on screen
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var userVM: UserViewModel
    @State var bottomSheetPosition: BottomSheetPosition = .bottom
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    @State var isOpen = false //maps to showSidebar
    
    @State var expandedTrends = false
    @State var showTrends: Bool = true
    
    var randomBusinesses : [Business] {
        homeVM.businesses.randomSelection(count: 4)
    }

    var button = RiveViewModel(fileName: "menu_button", stateMachineName: "State Machine", autoPlay: false/*, animationName: "open"*/)

    var body: some View {
        //MARK: Insert functionality to show sidebar on horizontal position / iPad
        ResponsiveView { prop in
            NavigationView { //include Navigation when we implement popToRoot functionality
                ZStack {
                    Color(hex: "17203A").ignoresSafeArea().opacity(isOpen ? 1 : 0)
                    
                    HStack(spacing: 0) {
                        //displaying only on iPad and not on split mode
                        if prop.isiPad && !prop.isSplit {
                            SideBar(prop: prop, selectedMenu: $selectedMenu)
                        }
                        
                        TabView(selection: $selectedMenu) {
                            HomeView(showSideBar: $isOpen, selectedMenu: $selectedMenu, expandedTrends: $expandedTrends, showTrends: $showTrends, randomBusinesses: randomBusinesses)
                                .tag(SelectedMenu.home)
                                .environmentObject(HomeViewModel())
                                .environmentObject(straddleScreen)
                                .environmentObject(UserViewModel())
                                                    #warning("uncomment this")
                            //                            .environmentObject(homeVM)
                            //                            .environmentObject(straddleScreen)
                            //                            .environmentObject(userVM)
                            
                            ProfileView()
                                .environmentObject(UserViewModel())
                                .tag(SelectedMenu.profile)
                            
                            VideoContentView()
                                .tag(SelectedMenu.create)
                            
                           SettingsView()
                                .tag(SelectedMenu.settings) //use VCard for badges
                            
                            if prop.isLandscape && !prop.isiPad {
                                VerticalContentView(verticalTabSelection: $tabSelection, selectedMenu: $selectedMenu, expandedTrends: $expandedTrends, showTrends: $showTrends)
                                    .tag(SelectedMenu.verticalContent)
                            } else {
                                VerticalContentView(verticalTabSelection: $tabSelection, selectedMenu: $selectedMenu, expandedTrends: $expandedTrends, showTrends: $showTrends)
                                    .tag(SelectedMenu.horizontalContent)
                            }
                        }
                        .toolbar(content: {
                            ToolbarItem(placement: isOpen ? .navigationBarLeading : .navigationBarTrailing) {
                                button.view()
                                    .frame(width: 30, height: 30)
                                    .mask(Circle())
                                    .shadow(color: Color("Background 2").opacity(0.2), radius: 5, x: 0, y: 5)
                                    .padding(.horizontal, .small)
                                //                    .offset(y: getRect().height * 0.001)
                                    .offset(x: isOpen ? 216 : 0) //may cause positioning issues. 216 is an arbitrary number which will not work on all screens. Easiest solution is to implement functionality to dismiss on tap outside SideMenu
                                    .onTapGesture {
                                        try? button.setInput("isOpen", value: isOpen)
                                        withAnimation(.spring(response: 0.2, dampingFraction: 1.5)) {
                                            isOpen.toggle()
                                        }
                                    }
                                    .onChange(of: isOpen) { newValue in
                                        if newValue {
                                            UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
                                        } else {
                                            UIApplication.shared.setStatusBarStyle(.darkContent, animated: true)
                                        }
                                    }
                            }
                        })
                        .ignoresSafeArea(.keyboard)
                        .mask(isOpen ? Rectangle().cornerRadius(30, corners: [.allCorners]) : Rectangle().cornerRadius(20, corners: [.bottomLeft, .bottomRight]))
                        .rotation3DEffect(.degrees(isOpen ? 30 : 0), axis: (x: 0, y: -1, z: 0), perspective: 1)
                        .offset(x: isOpen ? 265 : 0)
                        .scaleEffect(isOpen ? 0.9 : 1)
                        .ignoresSafeArea()
                    }
                    .overlay {
                        ZStack(alignment: .leading) {
                            Color.black
                                .opacity(isOpen ? 0.35 : 0)
                                .offset(x: isOpen ? 0 : -3000)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    //tapping outside SideBar will dismiss SideBar
                                    try? button.setInput("isOpen", value: isOpen)
                                    withAnimation(.spring(response: 0.2, dampingFraction: 1.5)) {
                                        isOpen.toggle()
                                    }
                                }
                            
                            SideBar(prop: prop, selectedMenu: $selectedMenu)
                                .transition(.move(edge: .leading))
                                .padding(.top, 50)
                                .opacity(isOpen ? 1 : 0)
                                .offset(x: isOpen ? 0 : -3000)
                                .rotation3DEffect(.degrees(isOpen ? 0 : 30), axis: (x: 0, y: 1, z: 0))
                                .ignoresSafeArea(.all, edges: .top)
                        }
                    }
                    
                    if prop.isLandscape && !prop.isiPad {
                        VerticalTabBar(verticalTabSelection: $tabSelection, selectedMenu: $selectedMenu)
                            .background(
                                LinearGradient(colors: [Color("Background").opacity(0), Color("Background")], startPoint: .top, endPoint: .bottom)
                                    .frame(height: 150)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                            )
                            .offset(y: getRect().height * 0.15) //using getRect to position this may not be the right thing to do
                            .offset(y: isOpen ? getRect().height * 2 : 0)
                    } else {
                        HorizontalTabBar(horizontalTabSelection: $tabSelection, selectedMenu: $selectedMenu)
                    }
                    
                    
                    //                    .onChange(of:!expandedTrends && !showTrends) {newValue in
                    //                        if newValue == true {
                    //                            self.opacity(0)
                    //                        } else {
                    //                            self.opacity(1)
                    //                        }
                    //                    }
                }
            }
        }
        .navigationTitle("Photo Memories")

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StraddleScreen())
            .environmentObject(UserPreference())
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
//            .previewInterfaceOrientation(.landscapeLeft)
    }
}
