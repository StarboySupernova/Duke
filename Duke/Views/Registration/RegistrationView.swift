//
//  RegistrationView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var userVM : UserViewModel
    
    @State private var isShowingPhotoPicker: Bool = false
    @State private var avatar: UIImage? = nil
    @State private var isLoading : Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 10) {
            Text("Let's Register a new account for you")
                .font(.largeTitle.bold())
                .horizontalAlign(.leading)
            
            Text("Onboarding")
                .font(.title3)
                .horizontalAlign(.leading)
            
            ScrollView(getRect().height < 750 ? .vertical : .init(), showsIndicators: true) {
                HelperView()
            }
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.white)
                
                Button {
                    dismiss()
                } label: {
                    Text("Login Now")
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                }

            }
            .font(.callout)
            //.verticalAlign(.bottom) - causing issues
        }
        .verticalAlign(.top)
        .padding(.large)
        .overlay {
            LoadingView(show: $isLoading)
        }
    }
    
    @ViewBuilder func HelperView () -> some View {
        //Should extract to separate ViewBuilder function named HelperView and optimize for smaller screen sizes
        VStack(spacing: 12) {
            ZStack {
                //CODE DUPLICATION HERE. SHOULD EXTRACT TO FUNCTION
                if self.avatar != nil {
                    Image(uiImage: self.avatar!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .background(
                            Color("unicorn")
                                .opacity(0.1)
                                .customCornerRadius(20, corners: [.topLeft, .bottomRight])
                                .glow(color: .green.opacity(0.02), radius: 1)
                        )
                        .padding()
                        .onTapGesture {
                            isShowingPhotoPicker = true
                        }
                } else {
                    Image(systemName: "person.badge.plus")
                        .renderingMode(.original)
                        .resizable()
                        .foregroundColor(Color.white)
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Rectangle())
                        .background(
                            LinearGradient(mycolors: .green, .clear, .clear, .black)
                                .opacity(0.5)
                                .customCornerRadius(15, corners: [.topLeft, .bottomRight])
                        )
                        .modifier(CompactConcaveGlassView())
                        .onTapGesture {
                            isShowingPhotoPicker = true
                        }
                }
            }
            .onTapGesture {
                isShowingPhotoPicker = true
            }
            .sheet(isPresented: $isShowingPhotoPicker) {
                isShowingPhotoPicker = false
            } content: {
                PhotoPicker(avatar: $avatar)
            }
            
            TextField("Username", text: $userVM.userName)
                .disableAutocorrection(true)
                .textContentType(.username)
                //.autocorrectionDisabled(true) ? not entirely sure why this is throwing an error
                .paddedBorder(.gray.opacity(0.5), 1)
                .padding(.top, .xLarge)

            TextField("Email", text: $userVM.email)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .paddedBorder(.gray.opacity(0.5), 1)
            
            SecureField("Password", text: $userVM.password)
                .textContentType(.newPassword)
                .textInputAutocapitalization(.never)
                .paddedBorder(.gray.opacity(0.5), 1)
            
            TextField("A little about Yourself (Optional)", text: $userVM.userBio)
                .textContentType(.jobTitle)
                .paddedBorder(.gray.opacity(0.5), 1)

            //MARK: iOS 16 code
            /*if #available(iOS 16.0, *) {
                TextField("A little about Yourself (Optional)", text: $userVM.userBio, axis: .vertical)
                    .frame(minHeight: 100, alignment: .top)
                    .textContentType(.emailAddress)
                    .paddedBorder(.gray.opacity(0.5), 1)
            } else {
                // Fallback on earlier versions
                TextField("A little about Yourself (Optional)", text: $userVM.userBio)
                    .textContentType(.jobTitle)
                    .paddedBorder(.gray.opacity(0.5), 1)
            }*/
            
            TextField("Link to Socials (Optional)", text: $userVM.userBioLink)
                .textContentType(.URL)
                .paddedBorder(.gray.opacity(0.5), 1)
                            
            Button {
                isLoading = true
                closeKeyboard()
                userVM.internalRegistration()
                isLoading = false
                dismiss()
            } label: {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .horizontalAlign(.center)
                    .fillView(.pink)
            }
            .disableWithOpacity(userVM.userName == "" || userVM.email == "" || userVM.password == "")
            .padding(.top, .medium)
        }
    }
}

struct InternalRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(UserViewModel())
            .preferredColorScheme(.dark)
    }
}
