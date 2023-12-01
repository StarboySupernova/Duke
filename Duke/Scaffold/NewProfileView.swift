//
//  NewProfileView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 10/26/23.
//


import SwiftUI
import CloudKit
import CoreData
import FirebaseAuth

struct NewProfileView: View {
    @State private var showSettingsView = false
    @State private var iapButtonTitle = "Purchase Lifetime Pro Plan"
    @State private var showActionAlert = false
    @State private var alertTitle = "Purchase Successful!"
    @State private var alertMessage = "You are now a Pro member and can access all courses"
    @State var updater: Bool = false

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showLoader = false
    
    var body: some View {
        ZStack {
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("pink-gradient-1"))
                                .frame(width: 66, height: 66, alignment: .center)
                            Image(systemName: "person.fill")
                                .font(.system(size: 24, weight: .medium, design: .rounded))
                        }
                        .frame(width: 66, height: 66, alignment: .center)
                        VStack(alignment: .leading) {
                            Text("No Name")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                            Text("View Profile")
                                .foregroundColor(.white).opacity(0.7)
                                .font(.footnote)
                        }
                        Spacer()
                        Button {
                            showSettingsView.toggle()
                        } label: {
                            TextfieldIcon(iconName: "gearshape.fill", passedImage: .constant(nil), currentlyEditing: .constant(true))
                        }
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.white.opacity(0.1))
                    Text("No Bio")
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                    Label(
                        title: { Text("Awarded certificates since") },
                        icon: { Image(systemName: "calendar") }
                    )
                    .foregroundColor(.white).opacity(0.7)
                    .font(.footnote)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.white.opacity(0.1))
                    HStack(spacing: 16) {
                        Image("profile")
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .center)
                            .foregroundColor(Color.white.opacity(0.7))
                        Image(systemName: "link")
                            .foregroundColor(Color.white.opacity(0.7))
                            .font(.system(size: 17, weight: .semibold))
                        Text( "No website")
                            .foregroundColor(Color.white.opacity(0.7))
                            .font(.footnote)
                    }
                }
                .padding(16)
                GradientButton(buttonTitle: iapButtonTitle) {

                }
                .alert(isPresented: $showActionAlert, content: {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
                })
                .padding(.horizontal, 16)

                Button {
                    showLoader = true
                } label: {
                    GradientText(text: "Restore Purchases")
                        .font(Font.footnote.bold())
                }
                .padding(.bottom)
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .dark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            )
            .cornerRadius(30)
            .padding(.horizontal)

            VStack {
                Spacer()
                Button {
                    // signOut()
                } label: {
                    Image(systemName: "arrow.turn.up.forward.iphone.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 0, z: 1))
                        .background(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                .frame(width: 40, height: 40, alignment: .center)
                                .overlay(
                                    VisualEffectBlur(blurStyle: .dark)
                                        .cornerRadius(20)
                                        .frame(width: 40, height: 40, alignment: .center)
                                )
                        )
                }
                .padding(.bottom, 64)

                if showLoader {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }
        .sheet(isPresented: $showSettingsView, content: {
            SettingsView()
                .environment(\.managedObjectContext, self.viewContext)
                .colorScheme(.dark)
                .onDisappear {
                    updater.toggle()
                }
        })
        .colorScheme(updater ? .dark : .dark)
        .onAppear() {
            
        }
    }

    func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            presentationMode.wrappedValue.dismiss()
        } catch let error {
            alertTitle = "Could not log out"
            alertMessage = error.localizedDescription
            showActionAlert.toggle()
        }
    }
}

struct NewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NewProfileView()
    }
}
