//
//  Home.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/3/22.
//

import SwiftUI
import BottomSheet

struct HomeView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @StateObject var userViewModel: UserViewModel = UserViewModel() 
    @StateObject var preferenceStore: UserPreference = UserPreference()
    @Environment(\.colorScheme) var colorScheme
    @State private var showLogin: Bool = false
    @State var selectedBusiness: Business?
    @State var press = false //might change this to a Binding passed down from ContentView
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
        //MARK: Insert functionality to show sidebar on horizontal position / iPad
        GeometryReader{ geometry in
            let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
            //let imageOffset = screenHeight + 36
            
            ZStack {
                NavigationView {
                    ZStack {
                        if colorScheme == .dark {
                            mainBackground
                                .zIndex(-1)
                        } else {
                            lightBackground
                                .zIndex(-1)
                        }
                        
                        VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                            //List
                            List(homeViewModel.businesses, id: \.id){ business in
                                BusinessCell(business: business)
                                    .listRowSeparator(.hidden)
                                    .onTapGesture {
                                        selectedBusiness = business
                                    }
                            }
                            .opacity(showLogin ? 0 : 1)
                            .listStyle(.plain)
                            .navigationTitle(homeViewModel.cityName)
                            .if(!showLogin, transform: { thisView in //conditional check should be done on variable toggled anytime tab button is pressed
                                thisView
                                    .searchable(text: $homeViewModel.searchText, prompt: Text(L10n.searchFood)) {
                                        ForEach(homeViewModel.completions, id : \.self) { completion in
                                            Text(completion).searchCompletion(completion)
                                                .foregroundColor(Color.white)
                                        }
                                        //.modifier(ConcaveGlassView())
                                    }
                            })
                            .toolbar {
                                //MARK: display profile image here
                                #warning("display profile image here")
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    accountButton
                                }
                            }
                            .safeAreaInset(edge: .bottom) {
                                Rectangle()
                                    .fill(LinearGradient(colors: [Color.pink.opacity(0.3), .black.opacity(0)], startPoint: .bottom, endPoint: .top))
                                    .frame(height: 190)
                            }
                            .edgesIgnoringSafeArea(.bottom)
                        }
                        .padding(.top, 51)
                        .offset(y: -bottomSheetTranslationProrated * 46)
                        
                        BottomSheetView(position: $bottomSheetPosition) {
                            #warning("display a heading here when sheet is activated")
                        } content: {
                            //control which view is shown here, depending on the tab button pressed
                            ForecastView(bottomSheetTranslationProrated: bottomSheetTranslationProrated)
                                .environmentObject(userViewModel)
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
                }
                /*.sheet(isPresented: $homeViewModel.showModal, onDismiss: nil) {
                 PermissionView() { homeViewModel.requestPermission() }
                 }*/
                .onChange(of: homeViewModel.showModal) { newValue in
                    homeViewModel.request()
                }
                
                if selectedBusiness != nil {
                    DetailView(id: selectedBusiness!.id!, selectedBusiness: $selectedBusiness)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.move(edge: .trailing))
                        .onAppear {
                            showLogin = false
                        }
                }
                
                //should control which tab toggles showLogin
                /*if showLogin {
                    LoginContainerView()
                        .environmentObject(userViewModel)
                }*/
            }
        }
    }
    
    var accountButton: some View {
        Button {
            withAnimation {
                showLogin.toggle()
                if bottomSheetPosition == .bottom {
                    bottomSheetPosition = .top
                } else {
                    bottomSheetPosition = .bottom //should bring up ForecastView (to be renamed)
                }
            }
            withAnimation(.spring()) {
                press = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    press = false
                }
            }
        } label: {
            if #available(iOS 16.0, *) {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 64, height: 44)
                    .foregroundStyle(
                        .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
                        .shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
                        .shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
                    )
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
                    .overlay(Image(systemName: "person.fill").foregroundStyle(.white))
                    .padding(.small)
            } else {
                // Fallback on earlier versions
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 64, height: 44)
                    .foregroundStyle(
                        .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
                    .overlay(Image(systemName: "arrowshape.turn.up.backward.fill").foregroundStyle(.white))
                    .padding(.small)
            }
        }
        .scaleEffect(press ? 1.2 : 1)
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}
