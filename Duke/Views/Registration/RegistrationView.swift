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
    @Binding var selection: Int
    
    var body: some View {
        VStack(spacing: 10) {
            GradientText(text: "Let's Register a new account for you")
                .font(.headline.bold())
                .horizontalAlign(.leading)
            
            GradientText(text: "Onboarding")
                .font(.title3)
                .horizontalAlign(.leading)
            
            ScrollView(getRect().height < 750 ? .vertical : .init(), showsIndicators: true) {
                Spacer()
                    .frame(height: .xLarge)
                HelperView()
            }
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.white)
                
                Button {
                    withAnimation(.spring()) {
                        selection = 0
                    }
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
                        .padding()
                        .background(
                            Circle()
                                .stroke(LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.6196078431, green: 0.6784313725, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5607843137, blue: 0.9803921569, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                        )
                        .onTapGesture {
                            isShowingPhotoPicker = true
                        }
                } else {
                    Image(systemName: "person.badge.plus")
                        .renderingMode(.original)
                        .resizable()
                        .foregroundColor(Color.white)
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Rectangle())
                        .background(
                            LinearGradient(mycolors: .black, .clear, .clear, .black)
                                .opacity(0.5)
                                .customCornerRadius(15, corners: [.topLeft, .bottomRight])
                        )
                        .background(Image("Background").opacity(0.5))
                        .modifier(CompactConcaveGlassView())
                        .glow(color: Color("pink"), radius: 3)
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
            
            TextField("", text: $userVM.userName)
                .placeholder(when: userVM.userName.isEmpty, systemImageName: "person.crop.circle.fill.badge.plus", placeholder: {
                    Text("Username").foregroundColor(.offWhite)
                })
                .disableAutocorrection(true)
                .textContentType(.username)
                .disableAutocorrection(true)
                .paddedBorder(.gray.opacity(0.5), 1)
                .padding(.top, .xLarge)

            TextField("", text: $userVM.email)
                .placeholder(when: userVM.email.isEmpty, systemImageName: "envelope.circle.fill", placeholder: {
                    Text("Email").foregroundColor(.offWhite)
                })
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .paddedBorder(.gray.opacity(0.5), 1)
            
            SecureField("", text: $userVM.password)
                .placeholder(when: userVM.password.isEmpty, systemImageName: "key.fill", placeholder: {
                    Text("Password").foregroundColor(.offWhite)
                })
                .textContentType(.newPassword)
                .textInputAutocapitalization(.never)
                .paddedBorder(.gray.opacity(0.5), 1)
            
            TextField("", text: $userVM.userBio)
                .placeholder(when: userVM.userBio.isEmpty,systemImageName: "pencil.and.outline", placeholder: {
                    Text("Bio (Optional)").foregroundColor(.offWhite)
                })
                .textContentType(.jobTitle)
                .paddedBorder(.gray.opacity(0.5), 1)
            
            #warning("re-add link/website here")
                                        
            GradientButton(buttonTitle: "Sign  Up") {
                isLoading = true
                closeKeyboard()
                userVM.internalRegistration()
                isLoading = false
                dismiss()
            }
            .disableWithOpacity(userVM.userName == "" || userVM.email == "" || userVM.password == "")
        }
    }
}

struct InternalRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(selection: .constant(1))
            .environmentObject(UserViewModel())
            .preferredColorScheme(.dark)
    }
}
