//
//  SeatsView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/6/23.
//

import SwiftUI

struct SeatsView: View {
    @Environment(\.dismiss) var dismiss
    @State var animate: Bool = false
    @State var showButton: Bool = false
    @State var seatType: String = "Standard"

    var body: some View {
        VStack(spacing: 0.0) {
            HStack {
                CircleButton(image: "arrow.left", action: {
                    dismiss()
                })
                
                Spacer()
                
                Text("Choose Seats")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(.top, 46)
            .padding(.horizontal, 20)
            
            Image("frontSeat")
                .padding(.top, 55)
                .glow(color: Color("pink"), radius: 20)
                .onTapGesture {
                    withAnimation(.spring()) {
                        showButton = true
                    }
                }

            
            Image("seats") //seats image not found in this project
                .frame(height: 240)
                .padding(.top, 60)
                .padding(.horizontal, 20)
                .onTapGesture {
                    withAnimation(.spring()) {
                        showButton = true
                    }
                }
            
            HStack {
                GradientButton(buttonTitle: "VIP") {
                    withAnimation(.spring()) {
                        seatType = "VIP"
                    }
                }
                
                GradientButton(buttonTitle: "Standard") {
                    withAnimation(.spring()) {
                        seatType = "Standard"
                    }
                }
            }
            .padding(.top, .large)
            
            ZStack(alignment: .topLeading) {
                Circle()
                    .frame(width: 200, height: 230)
                    .foregroundColor(Color("purple"))
                    .blur(radius: animate ? 70 : 100)
                    .offset(x: animate ? -100 : 20, y: animate ? -20 : 20) //offset is how they move onto the screen
                    .task {
                        withAnimation(.easeInOut(duration: 7).repeatForever()) {
                            animate.toggle()
                        }
                    }

                Circle()
                    .frame(width: 200, height: 230)
                    .foregroundColor(Color("lightBlue"))
                    .blur(radius: animate ? 50 : 100)
                    .offset(x: animate ? 50 : 70, y: animate ? 70 : 30)
                    .task {
                        withAnimation(.easeInOut(duration: 4).repeatForever()) {
                            animate.toggle()
                        }
                    }

                Circle()
                    .frame(width: 200, height: 230)
                    .foregroundColor(Color("pink"))
                    .blur(radius: animate ? 70 : 100)
                    .offset(x: animate ? 150 : 170, y: animate ? 90 : 100)
                    .task {
                        withAnimation(.easeInOut(duration: 2).repeatForever()) {
                            animate.toggle()
                        }
                    }
                
                VStack(alignment: .leading, spacing: 30.0) {
                    HStack(spacing: 10.0) {
                        Image(systemName: "calendar")
                        Text("April 28 , 2022")
                        Circle()
                            .frame(width: 6, height: 6)
                        Text("6 p.m.")
                    }
                    
                    HStack(spacing: 10.0) {
                        Image(systemName: "ticket.fill")
                        Text("\(seatType) Section")
                        Circle()
                            .frame(width: 6, height: 6)
                        Image(systemName: "cart.fill")
                    }
                    
                        
                    GradientButton(buttonTitle: "Continue") {
                        
                    }
                    .glow(color: .white.opacity(0.7), radius: 1)
                }
                .padding(42)
                .font(.subheadline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .clipped()
            .foregroundColor(.white)
            .background(.ultraThinMaterial)
            .padding(.top, 50)
//            .offset(y: showButton ? 0 : 250)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("backgroundColor-1"))
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

struct SeatsView_Previews: PreviewProvider {
    static var previews: some View {
        SeatsView()
    }
}
