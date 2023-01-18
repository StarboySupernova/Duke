//
//  ProfileView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var loginVM : UserViewModel
    //Profile Data
    @State private var isLoading: Bool = false //rename to processing
    var body: some View {
        VStack {
            MenuBar()
                .background (Color.pink.opacity(0.3))
                .customCornerRadius(10, corners: [.topLeft, .bottomRight])
#warning("find more elegant implementation here & restrict to safe area insets")
            
            ZStack {
                if loginVM.myProfile != nil {
                    ReusableProfileContent(user: loginVM.myProfile! /*?? User(userName: "Jon", userBio: "Sales", userBioLink: "jon@twitter.com", userUID: "jon", userEmail: "jon@gmail.com")*/)
                        .refreshable {
                            loginVM.myProfile = nil
                            do {
                                try await loginVM.fetchUser()
                            } catch {
                                await setError(error)
                            }
                        }
                } else {
                    ProgressView()
                        .frame(width: getRect().width * 0.95, height: getRect().height * 0.9)
                }
            }
        }
        .padding(.top, .small)
        .overlay {
            LoadingView(show: $isLoading)
        }
        .task {
            if loginVM.myProfile != nil { //fetch operation only occurs when myProfile is nil since task runs on view appear
                //show up to date notice here
                return
            }
            do  {
                try await loginVM.fetchUser()
            } catch {
                await setError(error)
            }
        }
        
        /*if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    if loginVM.myProfile != nil {
                        ReusableProfileContent(user: loginVM.myProfile!)
                            .refreshable {
                                loginVM.myProfile = nil
                                do {
                                    try await loginVM.fetchUser()
                                } catch {
                                    await setError(error)
                                }
                            }
                    } else {
                        ProgressView()
                    }
                }
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                isLoading = true
                                loginVM.internalUserLogout()
                                UserDefaults.standard.set(false, forKey: "sign_in_status")
                                isLoading = false
                            } label: {
                                Text("Logout")
                                    .foregroundColor(.white)
                            }
                            
                            Button(role: .destructive) {
                                isLoading = true
                                loginVM.deleteInternalUser()
                                UserDefaults.standard.set(false, forKey: "sign_in_status")
                                isLoading = false
                            } label: {
                                Text("Delete Account")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.init(degrees: 90))
                                .tint(.white)
                                .scaleEffect(0.8)
                        }
                    }
                }
            }
            .overlay {
                LoadingView(show: $isLoading)
            }
            .task {
                if loginVM.myProfile != nil { //fetch operation only occurs when myProfile is nil since task runs on view appear
                    //show up to date notice here
                    return
                }
                do  {
                    try await loginVM.fetchUser()
                } catch {
                    await setError(error)
                }
            }
        } else {
            // Fallback on earlier versions
            VStack {
                MenuBar()
                ScrollView(.vertical, showsIndicators: false) {
                    
                }
            }
            .padding(.top, .small)
        }*/
    }
    
    @ViewBuilder func MenuBar() -> some View {
        ZStack {
            HStack {
                Spacer()
                
                Menu {
                    Button {
                        isLoading = true
                        loginVM.internalUserLogout()
                        UserDefaults.standard.set(false, forKey: "sign_in_status")
                        isLoading = false
                    } label: {
                        Text("Logout")
                            .foregroundColor(.white)
                    }
                    
                    Button(role: .destructive) {
                        isLoading = true
                        loginVM.deleteInternalUser()
                        UserDefaults.standard.set(false, forKey: "sign_in_status")
                        isLoading = false
                    } label: {
                        Text("Delete Account")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: .large, weight: .bold, design: .rounded))
                        .rotationEffect(.init(degrees: 90))
                        .tint(.white)
                        .scaleEffect(0.8)
                        .frame(height: 30)
                }
                
            }
            .frame(height: 30)
            .padding(.horizontal, .medium)
        }
    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserViewModel())
            .preferredColorScheme(.dark)
    }
}
