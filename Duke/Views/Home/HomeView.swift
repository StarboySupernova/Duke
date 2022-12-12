//
//  Home.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/3/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView { //should replace these with ZStacks since NavigationViews are still unstable
            VStack {
                //Category
                Group {
                    Text(L10n.categories)
                        .bold()
                        .padding(.top, .small)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(FoodCategory.allCases, id: \.self) { category in
                                CategoryView(selectedCategory: $viewModel.selectedCategory, category: category)
                            }
                        }
                        .padding()
                    }
                }
                .padding(.leading, .large)

                //List
                List(viewModel.businesses, id: \.id){ business in
                    NavigationLink(destination: DetailView(id: business.id!)) {
                        BusinessCell(business: business)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle(viewModel.cityName)
                .searchable(text: $viewModel.searchText, prompt: Text(L10n.searchFood)) {
                    ForEach(viewModel.completions, id : \.self) { completion in
                        Text(completion).searchCompletion(completion)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "person")
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Rectangle()
                        .fill(LinearGradient(colors: [.white, .white.opacity(0)], startPoint: .bottom, endPoint: .top))
                        .frame(height: 90)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .sheet(isPresented: $viewModel.showModal, onDismiss: nil) {
                PermissionView() {viewModel.requestPermission()}
            }
            .onChange(of: viewModel.showModal) { newValue in
                viewModel.request()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}
