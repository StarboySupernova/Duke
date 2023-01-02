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
    //@State private var myProfile: InternalUser?
    @State private var isLoading: Bool = false //rename to processing
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    if loginVM.myProfile != nil {
                        ReusableProfileContent(user: loginVM.myProfile!)
                            .refreshable {
                                loginVM.myProfile = nil
                                do {
                                    try await loginVM.fetchUser()
                                    //myProfile = intraLoginVM.myProfile! //this code after try runs if no error is caught, hence it is safe to unwrap here
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
                                .tint(.black)
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
                    //myProfile = intraLoginVM.myProfile //this code after try runs if no error is caught, hence it is safe to unwrap here
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
        }
    }
    
    struct MenuBar: View {
        var body: some View {
            ZStack {
                HStack {
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                            .rotationEffect(.init(degrees: 90))
                            .font(.system(size: 20, weight: .bold))
                            .frame(height: 30)
                    }
                }
                .padding(.horizontal, .medium)
            }
        }
    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserViewModel())
    }
}
