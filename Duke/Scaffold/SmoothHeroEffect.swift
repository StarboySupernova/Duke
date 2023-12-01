//
//  SmoothHeroEffect.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 10/29/23.
//

//--------------------MOVIE Model

import SwiftUI
import MapKit

struct Movie: Identifiable {
    var id = UUID().uuidString
    var movieTitle: String
    var artwork: String
}

var movies : [Movie] = [
    Movie(movieTitle: "Ad Astra", artwork: "background12"),
    Movie(movieTitle: "Star Wars", artwork: "background8"),
    Movie(movieTitle: "Toy Story 3", artwork: "background7"),
    Movie(movieTitle: "Lion King", artwork: "background6"),
    Movie(movieTitle: "Spiderman", artwork: "background5"),
    Movie(movieTitle: "Shang Chi", artwork: "background4"),
    Movie(movieTitle: "HawkEye", artwork: "background13"),
]

struct SmoothHeroEffect: View {
    @State private var currentIndex: Int = 0
    @State private var currentTab: String = "Films"
    @Environment(\.colorScheme) var colorScheme
    @Namespace var animation
    //@State private var posts:[Post] = []
    
    //Detail View Properties
    @State private var detailMovie: Movie?
    @State private var showDetailView: Bool = false
    //For matched geometry effect, storing current card size
    @State private var currentCardSize: CGSize = .zero

    var body: some View {
        ZStack {
            BGView()

            VStack {
                NavBar()

                SnapCarousel(spacing: 20, trailingSpace: 110, index: $currentIndex, items: movies) { movie in
                    GeometryReader{ proxy in
                        let size = proxy.size

                        Image(movie.artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(15)
                        .matchedGeometryEffect(id: movie.id, in: animation)
                        .onTapGesture {
                            currentCardSize = size
                            detailMovie = movie
                            withAnimation(.easeInOut) {
                                showDetailView = true
                            }
                        }
                    }
                }
                .padding(.top, 70)

                //Custom Indicator
                CustomIndicator()
            }
            .overlay {
//                if let movie = detailMovie, showDetailView {
//                    HeroDetailView(movie: movie, showDetailView: $showDetailView, detailMovie: $detailMovie, currentCardSize: $currentCardSize, animation: animation)
//                }
            }
            .onAppear {
                for index in 1...5 {
                    //posts.append(Post(postImage: "post\(index)"
                }
            }
        }
    }
    
    @ViewBuilder func CustomIndicator() -> some View {
        HStack(spacing: 5) {
            ForEach(movies.indices, id: \.self) { index in
                Circle()
                .fill(currentIndex == index ? .blue : .gray)
                .frame(width: currentIndex == index ? 10 : 6, height: currentIndex == index ? 10 : 6)
            }
        }
        .animation(.easeInOut, value: currentIndex)
    }

    @ViewBuilder func NavBar() -> some View {
        HStack(spacing: 0)
        {
            ForEach(["Films", "Localities"], id: \.self) {tab in
                Button {
                    withAnimation {
                        currentTab = tab
                    }
                } label: {
                    Text(tab)
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 20)
                    .background (
                        Group {
                            if currentTab == tab {
                                Capsule()
                                .fill(.regularMaterial)
                                .environment(\.colorScheme, .dark)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                }
            }
        }
        .padding()
    }

    //Bulrred BG
    @ViewBuilder func BGView() -> some View {
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

            let color: Color = (colorScheme == .dark ? .black : .white)
            //Custom Gradient
            LinearGradient(colors: [.black, .clear, color.opacity(0.15), color.opacity(0.5), color.opacity(0.8), color, color], startPoint: .top, endPoint: .bottom)

            //blurred overlay
            Rectangle()
            .fill(.ultraThinMaterial) //enforce DarkModeViewModifier
        }
        .ignoresSafeArea()
    }
}

struct SmoothHeroEffect_Previews: PreviewProvider {
    static var previews: some View {
        SmoothHeroEffect()
    }
}

struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]

    //Properties
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index:Int

    init (spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }

    //Offset
    @GestureState var offset: CGFloat = 0
    @State private var currentIndex = 0

    var body: some View {
        GeometryReader { proxy in
            //Setting correct width for snap carousel...
            //One sided snap carousel...
//            let width = proxy.size.width - (trailingSpace - spacing)
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustmentWidth = (trailingSpace / 2) - spacing

            HStack(spacing: spacing) {
                ForEach(list) {item in
                    content(item)
                    .frame(width: proxy.size.width - trailingSpace)
                    .offset(y:getOffset(item: item, width: width))
                }
            }
            //spacing willl be horizontal padding...
            .padding(.horizontal, spacing)
            //setting only after 0th index
            .offset(x:(CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustmentWidth : 0) + offset)
            .gesture(
                DragGesture()
                .updating($offset, body: { value, out, _ in
                //making it a little bit slower
                    out = (value.translation.width / 1.5)
                })
                .onEnded({ value in
                    //Updating Current Index
                    let offsetX = value.translation.width

                    //we're going to convert the translation into progress (0-1)
                    //and round the value
                    //based on the progress increasing or decreasing the current index...
                    let progress = -offsetX / width
                    let roundIndex = progress.rounded()
                    
                    //                    //setting min...
                    currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)

//                    currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
//
//                    //updating index
                    currentIndex = index
                })
                .onChanged({ value in
                    //updating only index

                    //Updating Current Index
                    let offsetX = value.translation.width

                    //we're going to convert the translation into progress (0-1)
                    //and round the value
                    //based on the progress increasing or decreasing the current index...
                    let progress = -offsetX / width
                    let roundIndex = progress.rounded()

                    //setting min...
                    index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)

                })
            )
        }
        //animating when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }

    //moving view based on scroll offset
    func getOffset(item: T, width: CGFloat) -> CGFloat {
        //Progress
        //Shifting Current Item to Top...
        let progress = ((offset < 0 ? offset: -offset) / width) * 60

        //max 60...
        //then again minus from 60...
        let topOffset = -progress < 60 ? progress: -(progress + 120)

        let previous = getScrollIndex(item: item) - 1 == currentIndex ? (offset < 0 ? topOffset : -topOffset) : 0
        let next = getScrollIndex(item: item) + 1 == currentIndex ? (offset < 0 ? -topOffset : topOffset) : 0

        //safety check between 0 to max list size...
        let checkBetween = currentIndex >= 0 && currentIndex < list.count ? (getScrollIndex(item:item) - 1 == currentIndex ? previous : next) : 0

        //checking current...
        //if so, shifting view to top....
        return getScrollIndex(item: item) == currentIndex ? -60 - topOffset : checkBetween
        
    }

    // Fetching index
    func getScrollIndex(item: T) -> Int {
        let index = list.firstIndex { currentItem in
            return currentItem.id == item.id
        } ?? 0

        return index
    }
}

struct HeroDetailView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var id: String
    var business: Business
    @Binding var showDetailView: Bool
    @Binding var currentCardSize: CGSize

    var animation: Namespace.ID

    @State private var showDetailContent: Bool = false
    @State private var offset: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack {
                StandardBackButton {
                    //nulify the view
                }
                .matchedGeometryEffect(id: business.id, in: animation)
                
                VStack {
                    AsyncImage(url: business.formattedImageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.blue.shimmer()
                    }
                    .frame(width: currentCardSize.width, height: currentCardSize.height)
                    .cornerRadius(15)
                    .matchedGeometryEffect(id: business.id, in: animation)
                    
                    Map(coordinateRegion: $homeVM.region, annotationItems: homeVM.businessDetails != nil ? homeVM.businessDetails!.mapItems : []) {
                        MapMarker(coordinate: $0.coordinate, tint: .teal)
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                }
                .opacity(showDetailContent ? 1 : 0)
                .offset(y: showDetailContent ? 0 : 2000)
            }
            .modifier(HeroOffsetModifier(offset: $offset))
        }
        .onAppear {
            homeVM.requestDetails(forID: id)
            withAnimation(.easeInOut){
                showDetailContent = true
            }
        }
        .coordinateSpace(name: "SCROLL")
        .onChange(of: offset) { newValue in
            //Your own custom threshold
            if newValue > 120 {
                withAnimation(.easeInOut) {
                    showDetailContent = false
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation(.easeInOut) {
                    showDetailView = false
                }
                }
            }
        }
    }
}

//ScrollView Offset Reader
struct HeroOffsetModifier: ViewModifier {
    @Binding var offset: CGFloat

    func body(content: Content) -> some View {
        content
        .overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: .named("SCROLL")).minY

                Color.clear
                .preference(key: HeroOffsetKey.self, value: minY)
            }
            .onPreferenceChange(HeroOffsetKey.self) { minY in
                self.offset = minY
            }
        }
    }
}

struct HeroOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
