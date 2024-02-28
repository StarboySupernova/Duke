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
    
    @State var items = courses
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
    
    var trendingContent: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: expandedTrends ? 200 : 700))], spacing: 16) {
            ForEach(randomBusinesses.indices, id: \.self) { index in
                let flipView = FlipView(
                    business1: randomBusinesses[index],
                    business2: randomBusinesses[randomBusinesses.count - index - 1],
                    color1: gradients[index].color1,
                    color2: gradients[index].color2
                )
                    .frame(height: items[index].show ? 360 : 220)
                    .onTapGesture {
                        items[index].show.toggle()
                    }
                
                switch index {
                case 0:
                    flipView
                        .zIndex(3)
                case 1:
                    flipView
                        .offset(x: 0, y: expandedTrends ? 50 : -200)
                        .scaleEffect(expandedTrends ? 1 : 0.9)
                        .opacity(expandedTrends ? 1 : 0.3)
                        .zIndex(2)
                case 2:
                    flipView
                        .offset(x: 0, y: expandedTrends ? 100 : -450)
                        .scaleEffect(expandedTrends ? 1 : 0.8)
                        .opacity(expandedTrends ? 1 : 0.3)
                        .zIndex(1)
                default:
                    flipView
                        .offset(x: 0, y: expandedTrends ? 150 : 0)
                        .scaleEffect(expandedTrends ? 1 : 0.7)
                        .opacity(expandedTrends ? 1 : 0)
                        .zIndex(0)
                }
            }
        }
        .animation(.easeInOut(duration: 0.8))
        .padding(.all, 16)
    }
    
    var body: some View {
        //MARK: Insert functionality to show sidebar on horizontal position / iPad
        //MARK: Need to implement smooth functionality on landscape mode. This will need to be implemented in responsiveView, as I tried to wrap this inside a scrolview with unintended results. The scrollview blocks out the content
        ResponsiveView { prop in
            HStack(spacing: 0) {
                //will not turn into separate view, for it introduces additional complexity
                GeometryReader{ geometry in
                    /*
                     let showAdditionalDetails = prop.isiPad && !prop.isSplit && prop.isLandscape //MARK: Functionality for overlaying additional details on View. Adapted from Dashboard in ResponsiveLayout project 2
                     */
                    let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                    let imageOffset = screenHeight + 36
                    
                    ZStack {
                        NavigationView {
                            ZStack {
                                if !overlaid {
                                    VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                                        if showTrends {
                                            ScrollView(showsIndicators: false){
                                                VStack(spacing: .xLarge) {
                                                    if expandedTrends {
                                                        DateTitle(title: "Trending on Duke", location: homeViewModel.cityName, alignment: .trailing)
                                                            .foregroundColor(.offWhite)
                                                            .padding(.small)
                                                    } else {
                                                        DateTitle(title: "Trending on Duke", location: homeViewModel.cityName)
                                                            .foregroundColor(.offWhite)
                                                            .padding(.small)
                                                    }
                                                    
                                                    trendingContent
                                                }
                                                .overlay(alignment: expandedTrends ? .topLeading : .topTrailing) {
                                                    HStack(spacing: 2) {
                                                        ToggleButton(icon: expandedTrends ? "xmark.square" : "square.stack.3d.down.right") {
                                                            expandedTrends.toggle()
                                                            if expandedTrends {
                                                                trendingContentHeight = 450
                                                            } else {
                                                                trendingContentHeight = screenHeight * 1.1
                                                            }
                                                            shouldScroll.toggle()
                                                        }
                                                        .foregroundColor(expandedTrends ? .red : .offWhite)
                                                        
                                                        if !expandedTrends {
                                                            ToggleButton(icon: "xmark.square") {
                                                                withAnimation {
                                                                    showTrends.toggle()
                                                                }
                                                            }
                                                            .foregroundColor(.red)
                                                        }
                                                    }
                                                    .padding()
                                                }
                                                .padding(.top, expandedTrends ? 150 : 0)
                                            }
                                            .frame(height: expandedTrends ? getRect().height * 1.1 : 470)
                                            .padding(.top)
                                        }
                                        
                                        #warning("add this to swiftbank")
//                                        ScrollView(showsIndicators: false) {
//                                            ForEach(homeViewModel.businesses, id: \.id) { business in
//                                                CustomStackView {
//                                                    if business.id == homeViewModel.businesses.first?.id {
//                                                        DateTitle()
//                                                            .foregroundColor(.offWhite)
//                                                            .padding(.bottom, .large)
//                                                    } else {
//                                                        Label {
//                                                            Text(business.formattedCategory)
//                                                                .font(Font.subheadline.smallCaps()).bold()
//                                                        } icon: {
//                                                            Image(systemName: "clock")
//                                                        }
//                                                    }
//                                                } contentView: {
//                                                    GeometryReader { geometry in
//                                                        BusinessRow(business: business, size: geometry.size)
//                                                    }
//                                                    .frame(height: 100)
//                                                    .onTapGesture {
//                                                        selectedBusiness = business
//                                                    }
//                                                    .id(business.name ?? UUID().uuidString)
//                                                }
//                                                .padding(.medium)
//                                            }
//                                        }
//                                        .overlay(alignment: .topTrailing) {
//                                            ToggleButton {
//                                                withAnimation {
//                                                    showTrends.toggle()
//                                                }
//                                            }
//                                            .foregroundColor(.offWhite)
//                                            .padding()
//                                        }
                                            
                                        SplitListView(selectedBusiness: $selectedBusiness, expandedTrends: $expandedTrends)
                                            .offset(x: expandedTrends ? 3000 : 0)
                                            .offset(y: showTrends ? 20 : 0)
                                    }
                                    .offset(y: -bottomSheetTranslationProrated * 46)
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
                        }
//                        .fullScreenCover(isPresented: $homeViewModel.showModal, onDismiss: nil) {
//                            PermissionView() { homeViewModel.requestPermission() }
//                                .background(Color.clear) //PermissionView shows when LocationAccess is not given, however HeroParallaxView should show to repeat users
//                        }
                        .onAppear {
                            DispatchQueue.main.async {
                                #warning("add error propagation, calling this as is, is risky")
                                #warning("also test this on different simulator device")
                                homeViewModel.request()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeInOut(duration: 1)) {
                                    showTrends = false
                                }
                            }
                        }
                        .onChange(of: homeViewModel.showModal) { newValue in
                            homeViewModel.request()
                        }
//                        .onChange(of: !expandedTrends && !showTrends) { newValue in
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                straddleScreen.isHidden.toggle()
//                            }
//                        }
                        
                        if selectedBusiness != nil {
                            DetailView(id: selectedBusiness!.id!, selectedBusiness: $selectedBusiness)
                                .edgesIgnoringSafeArea(.all)
                                .transition(.move(edge: .trailing))
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
    
    @ViewBuilder func HeroBackgroundView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            TabView(selection:$currentIndex) {
                ForEach(movies.indices, id: \.self) { index in
                    Image(movies[index].artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentIndex)
            
            let color: Color = .black
            //Custom Gradient
            LinearGradient(colors: [.black, .clear, color.opacity(0.15), color.opacity(0.5), color.opacity(0.8), color, color], startPoint: .top, endPoint: .bottom)
            
            //blurred overlay
            Rectangle()
                .fill(.ultraThinMaterial) //enforce DarkModeViewModifier
        }
        .ignoresSafeArea()
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
