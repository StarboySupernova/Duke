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
    @State private var currentTab: SideMenuTab = .home //should become a Binding
    @Binding var showSideBar: Bool  
    
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
        
    /*
    init() {
        UITabBar.appearance().isHidden = true
    }
     */
    
    var body: some View {
        //MARK: Insert functionality to show sidebar on horizontal position / iPad
        ResponsiveView { prop in
            HStack(spacing: 0) {
                //displaying only on iPad and not on split mode
                if prop.isiPad && !prop.isSplit {
                    SideBar(prop: prop, currentTab: $currentTab)
                }
                
                
                //will not turn into separate view, for it introduces additional complexity
                GeometryReader{ geometry in
                    /*
                     let showAdditionalDetails = prop.isiPad && !prop.isSplit && prop.isLandscape //MARK: Functionality for overlaying additional details on View. Adapted from Dashboard in ResponsiveLayout project 2
                     */
                    let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                    //let imageOffset = screenHeight + 36
                    
                    ZStack {
                        NavigationView {
                            ZStack {
                                if #available(iOS 16, *), colorScheme == .light {
                                    GrayBackground()
                                        .zIndex(-10)
                                } else {
                                    DarkBackground(show: $hasDragged)
                                        .zIndex(-10)
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
                                            }
                                    })
                                    .toolbar(content: {
                                        ToolbarItem(placement: .navigationBarLeading) {
                                            if prop.isiPad && !prop.isSplit {
                                                Text("Dashboard")
                                                    .font(.title3)
                                                    .bold()
                                            } else {
                                                //menu button for sidebar
                                                Button {
                                                    withAnimation(.easeInOut) {
                                                        showSideBar = true
                                                    }
                                                } label: {
                                                    Image(systemName: "line.3.horizontal")
                                                        .font(.title2)
                                                        .foregroundColor(.white)
                                                    
                                                }
                                                .frame(maxWidth: 250)
                                            }
                                            
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
                    /* //MARK: Functionality for overlaying additional details on View. Adapted from Dashboard in ResponsiveLayout project 2
                     .overlay(alignment: .topTrailing) {
                     if showStorageDetails {
                     StorageDetailsView()
                     .frame(width: prop.size.width / 4)
                     }
                     }
                     */
                }
            }
        }
    }
    
    
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showSideBar: .constant(false))
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}
