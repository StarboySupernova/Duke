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
    @EnvironmentObject var straddleScreen: StraddleScreen //to handle verticalTab view's position onscreen to avoid having it block screen elements
    @State var bottomSheetPosition: BottomSheetPosition = .bottom
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    @State var isOpen = false //maps to showSidebar
    
    var button = RiveViewModel(fileName: "menu_button", stateMachineName: "State Machine", autoPlay: false/*, animationName: "open"*/)

    var body: some View {
        //MARK: Insert functionality to show sidebar on horizontal position / iPad
        ResponsiveView { prop in
            ZStack {
                Color(hex: "17203A").ignoresSafeArea().opacity(isOpen ? 1 : 0)
                
                // NavigationView { //include Navigation when we implement popToRoot functionality
                HStack(spacing: 0) {
                    //displaying only on iPad and not on split mode
                    if prop.isiPad && !prop.isSplit {
                        SideBar(prop: prop, selectedMenu: $selectedMenu)
                    }
                    
                    TabView(selection: $selectedMenu) {
                        HomeView(showSideBar: $isOpen, selectedMenu: $selectedMenu)
                            .environmentObject(HomeViewModel())
                            .tag(SelectedMenu.home)
                        
                        Text("Profile")
                            .tag(SelectedMenu.profile)
                        
                        Text("Create")
                            .tag(SelectedMenu.create)
                        
                        SeatsView()             
                            .tag(SelectedMenu.notifications)
                        
                        VerticalContentView(selectedMenu: $selectedMenu)
                            .tag(SelectedMenu.verticalContent)
                    }
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
                //}
                
                VerticalTabBar()
                    .background(
                        LinearGradient(colors: [Color("Background").opacity(0), Color("Background")], startPoint: .top, endPoint: .bottom)
                            .frame(height: 150)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    )
                    .offset(y: getRect().height * 0.15) //using getRect to position this may not be the right thing to do
                    .offset(y: isOpen ? getRect().height * 2 : 0)
                
                button.view()
                    .frame(width: 44, height: 44)
                    .mask(Circle())
                    .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 12)
                    .offset(y: getRect().height * 0.001)
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environmentObject(StraddleScreen())
    }
}
