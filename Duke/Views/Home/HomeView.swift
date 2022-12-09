//
//  Home.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/3/22.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView { //should replace these with ZStacks since NavigationViews are still unstable
            VStack {
                //Category
                Group {
                    Text("Categories")
                        .bold()
                        .padding(.leading, .large)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(FoodCategory.allCases, id: \.self) { category in
                                CategoryView(selectedCategory: $viewModel.selectedCategory, category: category)
                            }
                        }
                        .padding()
                    }
                }
                //List
                List(viewModel.businesses, id: \.id){ business in
                    NavigationLink(destination: DetailView()) {
                        BusinessCell(business: business)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Pretoria")
                .searchable(text: $viewModel.searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "person")
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
