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
    @State var selectedBusiness: Business?
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            List(homeViewModel.businesses, id: \.id){ business in
                BusinessCell(business: business)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        selectedBusiness = business
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
            
            if let selectedBusiness = selectedBusiness {
                withAnimation(.easeInOut) {
                    DetailView(id: selectedBusiness.id!)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.move(edge: .trailing))
                }
            }
        }
        /*.sheet(isPresented: $homeViewModel.showModal, onDismiss: nil) {
            PermissionView() { homeViewModel.requestPermission() }
        }*/
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
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}
