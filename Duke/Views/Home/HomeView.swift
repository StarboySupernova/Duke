//
//  Home.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/3/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @StateObject var userViewModel: UserViewModel = UserViewModel()
    @State private var showLogin: Bool = false
    
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
                                CategoryView(selectedCategory: $homeViewModel.selectedCategory, category: category)
                            }
                        }
                        .padding()
                    }
                }
                .padding(.leading, .large)

                //List
                List(homeViewModel.businesses, id: \.id){ business in
                    NavigationLink(destination: DetailView(id: business.id!)) {
                        BusinessCell(business: business)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle(homeViewModel.cityName)
                .searchable(text: $homeViewModel.searchText, prompt: Text(L10n.searchFood)) {
                    ForEach(homeViewModel.completions, id : \.self) { completion in
                        Text(completion).searchCompletion(completion)
                            .foregroundColor(Color.white)
                    }
                    .modifier(ConcaveGlassView())
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showLogin.toggle()
                        } label: {
                            Image(systemName: "person")
                        }
                        .buttonStyle(ColorfulButtonStyle())
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Rectangle()
                        .fill(LinearGradient(colors: [Color.pink.opacity(0.3), .black.opacity(0)], startPoint: .bottom, endPoint: .top))
                        .frame(height: 90)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .background(Color.black)
            .sheet(isPresented: $homeViewModel.showModal, onDismiss: nil) {
                PermissionView() { homeViewModel.requestPermission() }
            }
            .fullScreenCover(isPresented: $showLogin, onDismiss: {
                showLogin = false
            }, content: {
                LoginContainerView()
                    .environmentObject(userViewModel)
            })
            .onChange(of: homeViewModel.showModal) { newValue in
                homeViewModel.request()
            }
        }
        #warning("create home tabview that will be overlaid by get started view on each launch")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}
