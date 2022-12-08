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
        NavigationView { //should replace htese with ZStacks since NavigationViews are still unstable
            VStack {
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
                List {
                    ForEach(viewModel.businesses, id: \.id){ business in
                        Text(business.name ?? "")
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
                .onAppear {
                    viewModel.search()
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
