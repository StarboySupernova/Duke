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
    @EnvironmentObject var straddleScreen: StraddleScreen 
    @EnvironmentObject var userViewModel: UserViewModel
    //    @EnvironmentObject var preferenceStore: UserPreference
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismissSearch) private var dismissSearch
    @State var selectedBusiness: Business?
    @State var selectedTrendBusiness: Business?
    @State var overlaid = false
    @State var bottomSheetPosition: BottomSheetPosition = .bottom
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    @State private var currentTab: SideMenuTab = .home
    @State private var isLocationEnabled: Bool = false //to try and triiger view re-render on homeViewModal change
    @Binding var showSideBar: Bool
    @Binding var selectedMenu: SelectedMenu
    @Binding var expandedTrends: Bool
    @Binding var showTrends: Bool
    @State private var currentIndex: Int = 0
    @Namespace var animation
    //For matched geometry effect, storing current card size
    @State private var currentCardSize: CGSize = .zero
    @State private var showDetailView: Bool = false
    @State var position: CGPoint = .zero
    @State var isScrolling: Bool = false
    @State var offset: CGFloat = 0
    
    @State var businesses = placeholderBusinesses
    @State var shouldScroll: Bool = false
    
    @State var trendingContentHeight: CGFloat = 450
    
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    private let coordinateSpaceName = UUID()
    //MARK: axes is a hacky solution to control trendingContent from being able to scroll, given that it does not appears unless embedded in a scrollView
    private var axes: Axis.Set {
        return shouldScroll ? .vertical : []
    }
    
    let randomBusinesses: [Business]
    let monthDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    let weekDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "W"
        return formatter
    }()
    var currentDate = Date()
    
    var trendingContent: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: expandedTrends ? 200 : 700))], spacing: 16) {
            ForEach(businesses.indices, id: \.self) { index in
                let flipView = FlipView(
                    business1: businesses[index],
                    business2: businesses[placeholderBusinesses.count - index - 1],
                    color1: gradients[index].color1,
                    color2: gradients[index].color2
                )
                    .frame(height: 220)
                    .onTapGesture {
//                        businesses[index].show.toggle()
                    }
                
                switch index {
                case 0:
                    flipView
                        .zIndex(3)
                case 1:
                    flipView
                        .offset(x: 0, y: expandedTrends ? 0 : -200)
                        .scaleEffect(expandedTrends ? 1 : 0.9)
                        .opacity(expandedTrends ? 1 : 0.3)
                        .zIndex(2)
                case 2:
                    flipView
                        .offset(x: 0, y: expandedTrends ? 0 : -450)
                        .scaleEffect(expandedTrends ? 1 : 0.8)
                        .opacity(expandedTrends ? 1 : 0.3)
                        .zIndex(1)
                default:
                    flipView
                        .offset(x: 0, y: expandedTrends ? 0 : 0)
                        .scaleEffect(expandedTrends ? 1 : 0.7)
                        .opacity(expandedTrends ? 1 : 0)
                        .zIndex(0)
                }
            }
        }
        .animation(.easeInOut(duration: 0.8))
        .padding(.all, 16)
    }
    
    func refreshableOffset(offset: CGFloat) -> CGFloat {
        homeViewModel.request()
        return offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 : 0
    }
    
    func getTitleOffset() -> CGFloat {
        //setting a single max height for whole title
        //consider max as 120
        if offset < 0 {
            
            let progress = -offset / 120
            
            //since top padding is 25
            let newOffset = (progress <= 1.0 ? progress : 1) * 20
            
            return -newOffset
        }
        
        return 0
    }
    
    func getTitleOpacity() -> CGFloat {
        let titleOffset = -getTitleOffset()
        
        let progress = titleOffset / 20
        
        let opacity = 1 - progress
        
        return opacity
    }
    
    var body: some View {
        //MARK: Insert functionality to show sidebar on horizontal position / iPad
        //MARK: Need to implement smooth functionality on landscape mode. This will need to be implemented in responsiveView, as I tried to wrap this inside a scrolview with unintended results. The scrollview blocks out the content
        ResponsiveView { prop in
            HStack(spacing: 0) {
                ///will not turn into separate view, for it introduces additional complexity
                ///geometryreader for getting height and width
                GeometryReader { geometry in
                    /*
                     let showAdditionalDetails = prop.isiPad && !prop.isSplit && prop.isLandscape //MARK: Functionality for overlaying additional details on View. Adapted from Dashboard in ResponsiveLayout project 2
                     */
                    let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                    let imageOffset = screenHeight + 36
                    
                    ZStack { ///ZStack that allows BottomSheet and CustomTab to display in layers above the main content window (dependent on variables)
                        ZStack { ///ZStack to enable DetailView to overlay main view, without covering over the SideBar, which will be very import in the context of displaying on an iPad
                            VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack {
                                        DateTitle(title: homeViewModel.cityName, location: "Duke Home")
                                            .foregroundColor(.offWhite)
                                            .padding()
                                            .offset(y: -offset)
                                        //for bottom drag effect
                                            .offset(y: refreshableOffset(offset: offset))
                                            .offset(y: getTitleOffset())
                                            .opacity(getTitleOpacity())
                                        
                                        //Custom Data View
                                        VStack(spacing: 8) {
                                            //Custom Stack
                                            
                                            CustomStackView {
                                                //Label here
                                                Label {
                                                    Text("Trending - \(currentDate, formatter: monthDateFormat), Week \(currentDate, formatter: weekDateFormat)")
                                                        .font(Font.subheadline.smallCaps()).bold()
                                                } icon: {
                                                    Image(systemName: "clock")
                                                }
                                            } contentView: {
                                                //Content...
                                                LazyVGrid(columns: [GridItem(.adaptive(minimum: expandedTrends ? 200 : 700))], spacing: 16) {
                                                    ForEach(randomBusinesses.indices, id: \.self) { index in
                                                        let flipView = FlipView(
                                                            business1: randomBusinesses[index],
                                                            business2: randomBusinesses[randomBusinesses.count - index - 1],
                                                            color1: gradients[index].color1,
                                                            color2: gradients[index].color2
                                                        )
                                                            .frame(height: 220)
                                                            .onTapGesture {
                                                                
                                                            }
                                                        
                                                        switch index {
                                                        case 0:
                                                            flipView
                                                                .zIndex(3)
                                                        case 1:
                                                            flipView
                                                                .offset(x: 0, y: expandedTrends ? 0 : -200)
                                                                .scaleEffect(expandedTrends ? 1 : 0.9)
                                                                .opacity(expandedTrends ? 1 : 0.3)
                                                                .zIndex(2)
                                                        case 2:
                                                            flipView
                                                                .offset(x: 0, y: expandedTrends ? 0 : -450)
                                                                .scaleEffect(expandedTrends ? 1 : 0.8)
                                                                .opacity(expandedTrends ? 1 : 0.3)
                                                                .zIndex(1)
                                                        default:
                                                            flipView
                                                                .offset(x: 0, y: expandedTrends ? 0 : 0)
                                                                .scaleEffect(expandedTrends ? 1 : 0.7)
                                                                .opacity(expandedTrends ? 1 : 0)
                                                                .zIndex(0)
                                                        }
                                                    }
                                                }
                                                .animation(.easeInOut(duration: 0.8))
                                                .padding(.top, 16)
                                                .frame(height: 350, alignment: .top)
                                            }
                                            
                                            RestaurantListView()
                                        }
                                    }
                                    .padding(.top)
                                    .padding([.horizontal, .bottom])
                                    // getting offset....
                                    .overlay(
                                        //using GeometryReader
                                        GeometryReader { geometry -> Color in
                                            
                                            let minY = geometry.frame(in: .global).minY
                                            DispatchQueue.main.async {
                                                self.offset = minY
                                            }
                                            return Color.clear
                                        }
                                    )
                                }
                            }
                            .offset(y: -bottomSheetTranslationProrated * 46)
                            
                            if selectedBusiness != nil {
                                DetailView(id: selectedBusiness!.id!, selectedBusiness: $selectedBusiness)
                                    .edgesIgnoringSafeArea(.all)
                                    .transition(.move(edge: .trailing))
                            }
                        }
                        //                        .sheet(isPresented: $homeViewModel.showModal, onDismiss: nil) {
                        //                            PermissionView() { homeViewModel.requestPermission() }
                        //                                .background(Color.clear) //PermissionView shows when LocationAccess is not given, however HeroParallaxView should show to repeat users
                        //                        }
                        .onAppear {
                            DispatchQueue.main.async {
                                #warning("add error propagation, calling this as is, is risky")
                                #warning("also test this on different simulator device")
                                homeViewModel.request()
                            }
                        }
                        .onChange(of: homeViewModel.showModal) { _ in
                            homeViewModel.request()
                        }
                        
                        BottomSheetView(position: $bottomSheetPosition) {} content: {
                            SignInControllerView(bottomSheetTranslationProrated: bottomSheetTranslationProrated)
                                .environmentObject(userViewModel)
                                .modifier(DarkModeViewModifier())
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
                        
                        CustomPopUpSheetBar { //increase the height of this view
                            withAnimation {
                                bottomSheetPosition = .top
                                overlaid = true
                            }
#warning("straddle screen should be removed unless device is on landscape mode")
                            //                                    straddleScreen.isStraddling = true
                        }
                        .offset(y: bottomSheetTranslationProrated * 115) //- commenting this out made tab bar stop disappearing offscreen
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    .background (
                        ZStack {
                            if overlaid {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: getRect().width, height: getRect().height)
                                    .ignoresSafeArea()
                            } else {
                                Image("img_wave_1024x768")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width,
                                           height: UIScreen.main.bounds.height,
                                           alignment: .center)
                                    .scaledToFit()
                                    .clipped()
                                    .ignoresSafeArea()
                            }
                        }
                    )

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
        HomeView(showSideBar: .constant(false), selectedMenu: .constant(.home), expandedTrends: .constant(false), showTrends: .constant(true), randomBusinesses: [])
            .environmentObject(HomeViewModel())
            .environmentObject(StraddleScreen())
            .environmentObject(UserViewModel())
    }
}

extension Array where Element: Identifiable {
    func randomSelection(count: Int) -> [Element] {
        guard count > 0 else { return [] }
        let shuffledArray = self.shuffled()
        let selectedItems = Array(shuffledArray.prefix(count))
        return selectedItems
    }
}

struct SizingPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint { .zero }
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        // No-op
    }
}
