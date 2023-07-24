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
    @State var overlaid = false
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
                            .if(!showLogin && !overlaid, transform: { thisView in
                                thisView
                                    .searchable(text: $homeViewModel.searchText, prompt: Text(L10n.dukeSearch)) {
                                        ForEach(homeViewModel.completions, id : \.self) { completion in
                                            Text(completion).searchCompletion(completion)
                                                .foregroundColor(Color.white)
                                        }
                                        //.modifier(ConcaveGlassView())
                                    }
                            })
                            .safeAreaInset(edge: .bottom) {
                                Rectangle()
                                    .fill(LinearGradient(colors: [Color.pink.opacity(0.3), .black.opacity(0)], startPoint: .bottom, endPoint: .top))
                                    .frame(height: 190)
                            }
                            .edgesIgnoringSafeArea(.bottom)
                        }
                        .padding(.top, 51)
                        .offset(y: -bottomSheetTranslationProrated * 46)
                        .opacity(overlaid ? 0.1 : 1)
                        
                        BottomSheetView(position: $bottomSheetPosition) {
                            #warning("display a heading here when sheet is activated")
                        } content: {
                            SignInControllerView(bottomSheetTranslationProrated: bottomSheetTranslationProrated)
                                .environmentObject(userViewModel)
                        }
                        .onBottomSheetDrag { translation in
                            bottomSheetTranslation = translation / screenHeight
                            
                            withAnimation(.easeInOut) {
                                if bottomSheetPosition == BottomSheetPosition.top {
                                    hasDragged = true
                                } else {
                                    hasDragged = false
                                    withAnimation(.spring()) {
                                        overlaid = false
                                    }
                                }
                            }
                        }
                        
                        CustomPopUpSheetBar {
                            bottomSheetPosition = .top
                            overlaid = true
                        }
                        .offset(y: bottomSheetTranslationProrated * 115) //- commenting this out made tab bar stop disappearing offscreen
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
            }
        }
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}
