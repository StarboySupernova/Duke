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
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Let's Sign you in")
                .font(.largeTitle.bold())
                .horizontalAlign(.leading)
            
            Text("Welcome Back")
                .font(.title3)
                .horizontalAlign(.leading)
            
            VStack(spacing: 12) {
                TextField("Email", text: $loginVM.loginEmail)
                    .textContentType(.emailAddress)
                    .paddedBorder(.gray.opacity(0.5), 1)
                    .padding(.top, .xLarge)
                
                SecureField("Password", text: $loginVM.loginPassword)
                    .textContentType(.password)
                    .paddedBorder(.gray.opacity(0.5), 1)
                
                Button {
                    loginVM.resetPassword()
                } label: {
                    Text("Reset Password?")
                        .font(.callout)
                        .fontWeight(.medium)
                        .tint(.black)
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
                        .fillView(.black)
                }
                .padding(.top, .medium)
                
            }
            
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button {
                    createAccount.toggle()
                } label: {
                    Text("Register Now")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
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
        .fullScreenCover(isPresented: $createAccount) {
            RegistrationView()
        }
    }
}

struct InternalLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserViewModel())
    }
}

//MARK: UI View Extensions
extension View {
    /// Closes all active keyboards
    func closeKeyboard () {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func disableWithOpacity(_ condition : Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.4 : 1)
    }
    
    
    func horizontalAlign(_ alignment : Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func verticalAlign(_ alignment : Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    //MARK: Custom Border
    func paddedBorder(_ color: Color, _ linewidth : CGFloat) -> some View {
        self
            .padding(.horizontal, .large)
            .padding(.vertical, .medium)
        /*.background {
         RoundedRectangle(cornerRadius: 5, style: .continuous)
         .stroke(color, lineWidth: linewidth)
         }*/
    }
    
    //MARK: Custom Filling View
    func fillView(_ color: Color) -> some View {
        self
            .padding(.horizontal, .large)
            .padding(.vertical, .medium)
        /*.background {
         RoundedRectangle(cornerRadius: 5, style: .continuous)
         .fill(color)
         }*/
    }
    
}
