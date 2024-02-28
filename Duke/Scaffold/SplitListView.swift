//
//  SplitListView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/4/23.
//

import SwiftUI

struct SplitListView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var straddleScreen: StraddleScreen
    @Environment(\.dismissSearch) private var dismissSearch
    @Binding var selectedBusiness: Business?
    @Binding var expandedTrends: Bool
    @State private var currentIndex: Int = 0
    @State var position: CGPoint = .zero
    @Namespace var animation
    private let coordinateSpaceName = UUID()
    var isSearchable: Bool = false
    var cornerRadius: CGFloat?

    var body: some View {
        HStack(spacing: 2) {
            LeftList()
            
//            RightList()
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 0))
    }
    
    @ViewBuilder func LeftList() -> some View {
        List {
            Group {
                ForEach(homeViewModel.businesses, id: \.id) { business in
                    GeometryReader { geometry in
                        BusinessRow(business: business, size: geometry.size)
                    }
                    .frame(height: 100)
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Color.clear
                    )
                    .onTapGesture {
                        selectedBusiness = business
                    }
                    .id(business.name!)
                }
            }
            .background(GeometryReader { geometry in //to be added to search view
                Color.clear.preference(
                    key: SizingPreferenceKey.self,
                    value: geometry.frame(in: .named(coordinateSpaceName)).origin
                )
            })
        }
        .id(UUID()) //perfomance aid
        .onPreferenceChange(SizingPreferenceKey.self) { position in
            if (position.y > self.position.y) {
                print("up")
                dismissSearch()
            }
            else if (position.y < self.position.y) {
                #warning("should implement a counter that will keep track of how many list items a user has scrolled over, and display payment page after the threshold is reached")
                print("Down")
                dismissSearch()
            }
            dismissSearch()
            self.position = position
        }
        .refreshable(action: {
            homeViewModel.request()
        })
        .listStyle(.plain)
        .if(isSearchable, transform: { thisView in
            thisView
                .searchable(text: $homeViewModel.searchText, prompt: Text(L10n.dukeSearch)) {
                    ForEach(homeViewModel.completions, id : \.self) { completion in
                        Text(completion).searchCompletion(completion)
                            .foregroundColor(Color.white)
                    }
                }
        })
        .safeAreaInset(edge: .bottom) {
            Rectangle()
                .fill(LinearGradient(colors: [Color.pink.opacity(0.3), .black.opacity(0)], startPoint: .bottom, endPoint: .top))
                .frame(height: 190)
        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
    
    @ViewBuilder func RightList() -> some View {
        List {
            Group {
                ForEach(homeViewModel.businesses, id: \.id) { business in
                    GeometryReader { geometry in
                        BusinessRow(business: business, size: geometry.size)
                    }
                    .frame(height: 100)
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Color.clear
                    )
                    .onTapGesture {
                        selectedBusiness = business
                    }
                    .id(business.name!)
                }
            }
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: SizingPreferenceKey.self,
                    value: geometry.frame(in: .named(coordinateSpaceName)).origin
                )
            })
        }
        .id(UUID()) //perfomance aid
//        .onPreferenceChange(SizingPreferenceKey.self) { position in
//            if (position.y > self.position.y) {
//                print("up")
//                dismissSearch()
//                expandedTrends = false
//            }
//            else if (position.y < self.position.y) {
//                print("Down")
//                dismissSearch()
//                expandedTrends = false
//            }
//            self.position = position
//        }
        .refreshable(action: {
            homeViewModel.request()
        })
        .listStyle(.plain)
        .if(isSearchable, transform: { thisView in
            thisView
                .searchable(text: $homeViewModel.searchText, prompt: Text(L10n.dukeSearch)) {
                    ForEach(homeViewModel.completions, id : \.self) { completion in
                        Text(completion).searchCompletion(completion)
                            .foregroundColor(Color.white)
                    }
                }
        })
        .safeAreaInset(edge: .bottom) {
            Rectangle()
                .fill(LinearGradient(colors: [Color.pink.opacity(0.3), .black.opacity(0)], startPoint: .bottom, endPoint: .top))
                .frame(height: 190)
        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

//struct SplitListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplitListView(selectedBusiness: .constant(nil), businesses: [Business(alias: nil, categories: [.init(alias: nil, title: "Cafe")], coordinates: nil, displayPhone: nil, distance: nil, id: nil, imageURL: "https://loremflickr.com/g/620/440/paris", isClosed: nil, location: nil, name: "Blue bottle", phone: nil, price: nil, rating: 4.5, reviewCount: nil, transactions: nil, url: nil)])
//    }
//}
