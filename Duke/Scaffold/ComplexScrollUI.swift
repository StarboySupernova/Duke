//
//  ComplexScrollUI.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/14/24.
//

import SwiftUI
import BottomSheet

struct ComplexScrollUI: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State var offset: CGFloat = 0
//    @Binding var selectedBusiness: Business?
    @State private var selectedBusiness: Business?
//    @Binding var expandedTrends: Bool
    @State private var expandedTrends: Bool = false
    @State var businesses = placeholderBusinesses //change to randomBusinesses onAppear
    @State var overlaid = false
    @State var bottomSheetPosition: BottomSheetPosition = .bottom
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    
    var topEdge: CGFloat
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
    
    var color1: Color = Color(red: 0.992, green: 0.247, blue: 0.2)
    var color2: Color = Color(red: 0.298, green: 0, blue: 0.784)
    
    var body: some View {
        ResponsiveView { prop in
            HStack(spacing: 0) {
                ///SideBar coming here
                
                
                ///will not turn into separate view, for it introduces additional complexity
                ZStack {
                    
                    ///geometryreader for getting height and width
                    GeometryReader{ geometryProxy in
                        let screenHeight = geometryProxy.size.height + geometryProxy.safeAreaInsets.top + geometryProxy.safeAreaInsets.bottom
                        let imageOffset = screenHeight + 36
                        
                        ZStack {
                            VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack {
                                        DateTitle(title: "homeViewModel.cityName", location: "Duke Home")
                                            .foregroundColor(.offWhite)
                                            .padding()
                                            .offset(y: -offset)
                                        //for bottom drag effect
                                            .offset(y: refreshableOffset(offset: offset))
                                            .offset(y: getTitleOffset())
                                        
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
                                                    ForEach(businesses.indices, id: \.self) { index in
                                                        let flipView = FlipView(
                                                            business1: businesses[index],
                                                            business2: businesses[placeholderBusinesses.count - index - 1],
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
                            
                            CustomPopUpSheetBar {
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
                    ///this will be appened to the View inside GeometryReader. If effects are unpredictable then move back here on the GeometryReader proper
                    ///.offset(y: -bottomSheetTranslationProrated * 46)
                }
            }
        }
    }
    
    var randomBusinesses : [Business] {
        homeViewModel.businesses.randomSelection(count: 4)
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
    
    @ViewBuilder func RestaurantListView() -> some View {
        VStack(spacing: 8){
            ForEach(homeViewModel.businesses, id: \.id) { business in
                CustomStackView {
                    Label {
                        Text(business.name ?? "")
                    } icon : {
                        Image(systemName: "circle.hexagongrid.fill")
                    }
                } contentView: {
                    GeometryReader { geometry in
                        BusinessRow(business: business, size: geometry.size)
                    }
                    .frame(height: 100)
                    .onTapGesture {
                        selectedBusiness = business
                    }
                    .id(business.name ?? UUID().uuidString)
                }
            }
            
            HStack {
                CustomStackView {
                    Label {
                        Text("Auteuristic/Repertoire")
                    } icon: {
                        Image(systemName: "heater.vertical")
                    }
                } contentView: {
                    ScrollView(.horizontal, showsIndicators: false) {
                        ForEach(randomBusinesses.randomElement()?.categories ?? []) { category in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(category.title!)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                
                                Text(randomBusinesses[1].isClosed ?? false ? "Closed" : "Open")
                                    .font(.title)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                CustomStackView {
                    Label {
                        Text("Top Restaurateurs")
                    } icon: {
                        Image(systemName: "line.horizontal.star.fill.line.horizontal")
                    }
                } contentView: {
                    ScrollView(.horizontal, showsIndicators: false) {
                        ForEach(randomBusinesses) { business in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(business.name ?? "Business")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                
                                Text(business.price ?? "$8.00")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        
    }

}


struct CustomStackView<Title: View, Content: View>: View {
    var titleView: Title
    var contentView: Content
    
    //Offsets
    @State private var topOffset: CGFloat=0
    @State private var bottomOffset: CGFloat=0
    
    var color1: Color = Color(red: 0.992, green: 0.247, blue: 0.2)
    var color2: Color = Color(red: 0.298, green: 0, blue: 0.784)
    
    init (@ViewBuilder titleView: @escaping ()-> Title, @ViewBuilder contentView: @escaping () -> Content) {
        self.contentView = contentView()
        self.titleView = titleView()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .font(.callout)
                .lineLimit(1)
            //max height
                .frame(height: 38)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .background(RadialGradient(gradient: Gradient(colors: [color1, color2]), center: .topLeading, startRadius: 5, endRadius: 500), in: RoundedCorner(radius: 12, corners: bottomOffset < 38 ? .allCorners : [.topLeft, .topRight]))
                .zIndex(1)
            
            VStack {
                Divider().glow(color: .black)
                
                contentView
                    .padding()
            }
            .background(RadialGradient(gradient: Gradient(colors: [color1, color2]), center: .topLeading, startRadius: 5, endRadius: 500), in: RoundedCorner(radius: 12, corners: [.bottomLeft, .bottomRight]))
            .shadow(color: color2.opacity(0.3), radius: 20, x: 0, y: 10)
            //Moving content Upward
            .offset(y: topOffset >= 120 ? 0 : -(-topOffset + 120))
            .zIndex(0)
            //clipping to avoid background overlay
            .clipped()
            .opacity(getOpacity())
        }
        .colorScheme(.dark)
        .cornerRadius(12)
        .opacity(getOpacity())
        //stopping View at 120
        .offset(y: topOffset >= 120 ? 0 : -topOffset + 120)
        .background(
            GeometryReader{ geometry -> Color in
                let minY = geometry.frame(in: .global).minY
                let maxY = geometry.frame(in: .global).maxY
                
                DispatchQueue.main.async {
                    self.topOffset = minY
                    self.bottomOffset = maxY - 120
                }
                
                return Color.clear
            }
        )
        .modifier(CornerModifier(bottomOffset: $bottomOffset))
    }
    
    func getOpacity() -> CGFloat {
        if bottomOffset < 28 {
            let progress = bottomOffset / 28
            return progress
        }
        
        return 1
    }
}

struct CornerModifier: ViewModifier {
    @Binding var bottomOffset: CGFloat
    
    func body(content: Content) -> some View {
        if bottomOffset < 38 { //38 is the title height we gave
            content
        } else {
            content
                .cornerRadius(12)
        }
    }
}

struct ComplexScrollUI_Previews: PreviewProvider {
    static var previews: some View {
        ComplexContentView()
            .environmentObject(HomeViewModel())
            .environmentObject(UserViewModel())
    }
}

struct ComplexContentView: View {
    var body: some View {
        //getting safe area using GeometryReader since window is deprecated in ios15
        GeometryReader { geometry in
            let topEdge = geometry.safeAreaInsets.top
            ComplexScrollUI(topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
                .environmentObject(HomeViewModel())
        }
    }
}

