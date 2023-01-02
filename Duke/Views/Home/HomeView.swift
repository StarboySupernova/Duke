//
//  Home.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/3/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
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
                        .fill(LinearGradient(colors: [Color("Launchscreen-background"), .black.opacity(0)], startPoint: .bottom, endPoint: .top))
                        .frame(height: 90)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .background(Color.black)
            .sheet(isPresented: $viewModel.showModal, onDismiss: nil) {
                PermissionView() {viewModel.requestPermission()}
            }
            .fullScreenCover(isPresented: $showLogin, onDismiss: {
                showLogin = false
            }, content: {
                //login screen will come here
            })
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
            .preferredColorScheme(.dark)
    }
}
