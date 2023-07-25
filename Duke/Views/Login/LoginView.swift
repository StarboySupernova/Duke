//
//  LoginView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI

struct LoginView: View {
    //internal employee login credentials
    //@State private var password: String = ""
    //@State private var email : String = ""
    @State private var createAccount : Bool = false
    @State private var isLoading : Bool = false
    @EnvironmentObject var loginVM: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var selection: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Let's Sign you in")
                .foregroundColor(.white)
                .font(.largeTitle.bold())
                .horizontalAlign(.leading)
            
            Text("Welcome Back")
                .foregroundColor(.white)
                .font(.title3)
                .horizontalAlign(.leading)
            
            VStack(spacing: 12) {
                TextField("Email", text: $loginVM.loginEmail)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .paddedBorder(.gray.opacity(0.9), 1)
                    .padding(.top, .xLarge)
                
                SecureField("Password", text: $loginVM.loginPassword)
                    .textInputAutocapitalization(.never)
                    .textContentType(.password)
                    .paddedBorder(.gray.opacity(0.9), 1)
                    .foregroundColor(.white)
                
                Button {
                    loginVM.resetPassword()
                } label: {
                    Text("Reset Password?")
                        .foregroundColor(.white)
                        .font(.callout)
                        .fontWeight(.medium)
                        .tint(.white)
                        .horizontalAlign(.trailing)
                }
                
                Button {
                    isLoading = true
                    closeKeyboard()
                    loginVM.internalLogin()
                    isLoading = false
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .horizontalAlign(.center)
                        .fillView(.pink)
                }
                .padding(.top, .medium)
                
            }
            
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.white)
                
                Button {
                    withAnimation(.spring()) {
                        selection = 1
                    }
                } label: {
                    Text("Register Now")
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                }
                
            }
            .font(.callout)
            .verticalAlign(.bottom)
        }
        .verticalAlign(.top)
        .padding(.large)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
    }
}

struct InternalLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(selection: .constant(0))
            .environmentObject(UserViewModel())
            .preferredColorScheme(.dark)
    }
}


