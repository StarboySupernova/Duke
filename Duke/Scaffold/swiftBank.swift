//
//  swiftBank.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/31/24.
//

import SwiftUI

struct BankCard: Identifiable, Hashable {
    var id: UUID = .init()
    var cardName: String
    var cardColor: Color
    var cardBalance: String
    var isFirstBlankCard: Bool = false
    var expenses: [Expense] = []
}

struct Expense: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var amountSpent: String
    var product: String
    var productIcon: String
    var spendType: String
}

var sampleBankCards: [BankCard] = [
    BankCard(cardName: "", cardColor: .red, cardBalance: "", isFirstBlankCard: true, expenses: []),
    BankCard(cardName: "Card2", cardColor: .blue, cardBalance: "$1000", isFirstBlankCard: false, expenses: []),
    BankCard(cardName: "Card3", cardColor: .green, cardBalance: "$1000", isFirstBlankCard: false, expenses: []),
    BankCard(cardName: "Card4", cardColor: .orange, cardBalance: "$1000", isFirstBlankCard: false, expenses: []),
    BankCard(cardName: "Card5", cardColor: .purple, cardBalance: "$1000", isFirstBlankCard: false, expenses: []),
    BankCard(cardName: "Card6", cardColor: .pink, cardBalance: "$1000", isFirstBlankCard: false, expenses: []),
    BankCard(cardName: "Card7", cardColor: .yellow, cardBalance: "$1000", isFirstBlankCard: false, expenses: [])
]

//the first is the card to be expanded, so it has no data

struct SliderView: View {
    var proxy: ScrollViewProxy
    var size: CGSize
    var safeArea: EdgeInsets
    /// View Properties
    @State private var activePage: Int = 1
    @State private var myCards: [BankCard] = sampleBankCards
    /// Page Offset
    @State private var offset: CGFloat = 0
    @State var shouldScroll: Bool = true
    @State private var isScrollActionPending: Bool = false
    @State var expandedTrends = false
    @State var selectedBusiness: Business?

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ProfileCard()
                
                ///Indicator
                Capsule()
                    .fill(.gray.opacity(0.2))
                    .frame(width:50, height:5)
                    .padding(.vertical, 5)
                
                ///Page Tab View Height Based on Screen Height
                let pageHeight = size.height * 0.65
                ///PageTab View
                //To Keep track of minY
                GeometryReader {
                    let geometry = $0.frame(in: .global)
                    
                    TabView(selection: $activePage) {
                        ForEach(myCards) { card in
                            ZStack{
                                if card.isFirstBlankCard {
                                    Rectangle()
                                        .fill(.clear)
                                } else  {
                                    /// Card View
                                    CardView(card: card)
                                }
                            }
                            .frame(width: geometry.width - 60)
                            ///Page Tag (Index)
                            .tag(index(card))
                            .offsetX(activePage == index(card)) { rect in
                                //Calculating Entire Page Offset
                                let minX = rect.minX
                                let pageOffset = minX - (size.width * CGFloat(index(card)))
                                offset = pageOffset
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background(
                        SplitListView(selectedBusiness: $selectedBusiness, expandedTrends: $expandedTrends, isSearchable: true, cornerRadius: 40 * reverseProgress(size))
                            .glow(color: .red, radius: reverseProgress(size))
                        //                                            .offset(x: expandedTrends ? 3000 : 0)
                        //                                            .offset(y: showTrends ? 20 : 0)
                            .environmentObject(HomeViewModel())
                            .environmentObject(StraddleScreen())
                            .frame(height: pageHeight + fullScreenHeight(size, pageHeight, safeArea: safeArea))
                        ///Expanding to Full Screen, Based on the Progress
                            .frame(width:geometry.width - (60 * reverseProgress(size)), height:pageHeight, alignment: .top)
                        /// Making it a little visible at Idle
                            .offset(x:-15 * reverseProgress(size))
                            .scaleEffect(0.95 + (0.05 * progress(size)), anchor: .leading)
                        /// Moving along side with the second card
                            .offset(x: (offset + size.width) < 0 ? (offset + size.width) : 0)
                            .offset(y: (offset + size.width) > 0 ? (-geometry.minY * progress(size)): 0) //achieving true full screen, from using global proxy(geometry)
                    )
                }
                .frame(height: pageHeight)
                .zIndex(1000)
                
//                Text("Helter")
//                    .padding(.horizontal, 30)
//                    .padding(.top, 30)
            }
            .padding(.top, safeArea.top + 15)
            .padding(.bottom, safeArea.bottom + 15)
            .id("CONTENT")
        }
        .overlay(content : {
            if reverseProgress(size) < 0.15 && activePage == 0 {
                EmptyView()
                ///adding animation
                .scaleEffect(1 - reverseProgress(size))
                .opacity(1.0 - (reverseProgress(size) / 0.15))
                .transition(.identity)
            }
        })
        .onChange(of: offset) { newValue in
            if !isScrollActionPending && newValue == 0 && activePage == 0 {
                isScrollActionPending = true // Set the flag to prevent further scrolling in this cycle
                proxy.scrollTo("CONTENT", anchor: .topLeading)
            }
        }
        .onChange(of: activePage) { _ in
            isScrollActionPending = false // Reset the flag when activePage changes
        }
    }
    
    private var axes: Axis.Set {
        if activePage == 0 {
            shouldScroll = false
            return []
        } else {
            shouldScroll = true
            return .vertical
        }
    }

    ///Profile Card View
    @ViewBuilder func ProfileCard () -> some View {
        HStack(alignment: .center, spacing: 4){
            Text("Hello")
            .font(.title)

            Text("JUstine")
            .font(.title)
            .fontWeight(.bold)

            Spacer(minLength: 0)

            Image("Pic")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width:55, height:55)
            .clipShape(Circle())
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 35)
        .background(
            RoundedRectangle(cornerRadius:35, style: .continuous)
            .fill(Color("Profile"))
        )
        .padding(.horizontal, 30)
        
    }

    ///Returns Index for Given Card
    func index(_ of: BankCard) -> Int {
        return myCards.firstIndex(of: of) ?? 0
    }

    ///Full Screen Height
    func fullScreenHeight(_ size: CGSize, _ pageHeight: CGFloat, safeArea: EdgeInsets) -> CGFloat {
        let progress = progress(size)
        let remainingScreenHeight = progress * (size.height - (pageHeight - safeArea.top - safeArea.bottom))

        return remainingScreenHeight
    }

    /// Converts Offset Into Progress
    /// (0 - 1)
    func progress(_ size: CGSize) -> CGFloat {
        let pageOffset = offset + size.width
        let progress = pageOffset / size.width

        return min(progress, 1)
    }

    //Reverse Progress(1 - 0)
    func reverseProgress(_ size: CGSize) -> CGFloat {
        let progress = 1  - progress(size)
        return max(progress, 0)
    }
}

struct BankContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            ScrollViewReader { proxy in
                SliderView(proxy: proxy, size: size, safeArea: safeArea)
            }
            .preferredColorScheme(.light)
            .ignoresSafeArea()
        }
    }
}

///Card View
struct CardView: View {
    var card: BankCard

    var body: some View {
        GeometryReader {
            let size = $0.size

            VStack(spacing: 0){
                 Rectangle()
                    .fill(LinearGradient(colors: [card.cardColor, .offWhite], startPoint: .top, endPoint: .bottom))
                 ///Card Details
                 .overlay(alignment: .top) {
                    VStack {
                        HStack {
                            Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:65, height:65)

                            Spacer(minLength: 0)

                            Image(systemName: "wave.3.right")
                            .font(.largeTitle.bold())
                        }

                        Spacer(minLength: 0)

                        Text(card.cardBalance)
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    }
                    .padding(30)
                 }

                 Rectangle()
                    .fill(.black)
                    .frame(height: size.height / 3)
                    ///Card Details
                    .overlay {
                        VStack {
                            Text(card.cardName)
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer(minLength: 0)

                            HStack {
                                Text("Debit Card")
                                .font(.callout)

                                Spacer(minLength: 0)

                                Image("Visa")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(25)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius:40, style: .continuous))

        }
    }
    
}

//Offset Preference Key

struct BankOffsetKey: PreferenceKey {
 static var defaultValue: CGRect = .zero

 static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
 }
    
}

extension View {
    //Offset View Modifier
    @ViewBuilder func offsetX(_ addObserver: Bool, completion: @escaping (CGRect) -> ()) -> some View {
        self
            .frame(maxWidth: .infinity)
            .overlay {
                if addObserver {
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        
                        Color.clear
                            .preference(key: BankOffsetKey.self, value: rect)
                            .onPreferenceChange(BankOffsetKey.self, perform: completion)
                    }
                }
            }
    }
    
}

struct swiftBank_Previews: PreviewProvider {
    static var previews: some View {
        BankContentView()
    }
}
