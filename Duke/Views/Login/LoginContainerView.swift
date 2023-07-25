//
//  LoginContainerView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/1/23.
//

import SwiftUI

struct LoginContainerView: View {
    @EnvironmentObject var userLoginVM: UserViewModel
    var body: some View {
        if userLoginVM.sign_in_status {
            //MARK: Tab View with Profile & Recent Posts
            TabView {
                PostsView()
                    .tabItem {
                        Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                        Text("Posts")
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Profile")
                    }
            }
            .tint(.pink)
        } else {
            LoginView(selection: .constant(0))
        }
    }
}

struct LoginContainerView_Previews: PreviewProvider {
    static var previews: some View {
        LoginContainerView()
            .preferredColorScheme(.dark)
            .environmentObject(UserViewModel())
    }
}
