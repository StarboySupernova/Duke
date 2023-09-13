//
//  ContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/2/22.
//

import SwiftUI
import CoreLocationUI
import MapKit


struct PermissionView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var isAnimating: Bool = false
    @State private var showMap: Bool = false
    let action : () -> Void
    
    var animation : Animation {
        .interpolatingSpring(stiffness: 0.5, damping: 0.5)
        .delay(isAnimating ? .random(in: 0...1) : 0)
        .speed(isAnimating ? .random(in: 0.3...1) : 0)
    }
    
    var body: some View {
        GeometryReader { geometry  in
            VStack(alignment: .center) {
                ZStack {
                    ForEach(1..<14, id: \.self) { index in
                        Image("food\(index % 7)")
                        //self positioning through geometry bounds
                            .position(x: .random(in: 0...geometry.size.width),
                                      y: .random(in: 0...geometry.size.height / 2)
                            )
                            .animation(animation, value: isAnimating)
                    }
                }
                .frame(height: geometry.size.height / 3)
                
                Spacer()
                
                VStack {
                    Text("Duke")
                        .font(.largeTitle)
                        .fontWeight(.ultraLight)
                        .padding(.bottom, .large)
                    
                    Text("Event Search Companion App")
                        .font(.headline)
                }
                .padding()
                .background (
                    ZStack{
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: getRect().width * 0.7, height: getRect().height * 0.3)
                          .background(
                            LinearGradient(
                              stops: [
                                Gradient.Stop(color: Color(red: 0.45, green: 0.72, blue: 0.98), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.8, green: 0.85, blue: 0.95), location: 1.00),
                              ],
                              startPoint: UnitPoint(x: 0.5, y: 0.12),
                              endPoint: UnitPoint(x: 0.5, y: 0.81)
                            )
                          )
                          .cornerRadius(60)
                          .rotationEffect(Angle(degrees: 6.19))

                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: getRect().width * 0.7, height: getRect().height * 0.3)
                          .background(.white.opacity(0.3))
                          .shadow(color: .black.opacity(0.25), radius: 50, x: 0, y: 50)
                          .overlay(
                            Rectangle()
                              .inset(by: 0.25)
                              .stroke(.white.opacity(0.5), lineWidth: 0.5)
                          )
                    }
                        .frame(width: getRect().width * 0.7, height: getRect().height * 0.3)
                        .cornerRadius(60, corners: [.topRight, .bottomRight])
                )
                
                
                Spacer()
                
                Button {
                    action()
                } label: {
                    Text(L10n.getStarted)
                        .bold()
                }
                .padding()
                .frame(width: geometry.size.width * 0.7)
                .background(colorScheme == .light ? Color.black : Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                
                Spacer()
            }
            .frame(maxWidth: getRect().width * 0.95)
        }
        .background(
            ZStack {
                HeroParallaxView()
                    .opacity(0.9)
                LinearGradient(
                stops: [
                Gradient.Stop(color: Color(red: 0.45, green: 0.72, blue: 0.98), location: 0.00),
                Gradient.Stop(color: Color(red: 0.8, green: 0.85, blue: 0.95), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0.12),
                endPoint: UnitPoint(x: 0.5, y: 0.81)
                )
                .ignoresSafeArea()
                .opacity(0.8)
            }
        )
        .onAppear {
            isAnimating.toggle()
        }
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView() {}
            .preferredColorScheme(.light)
    }
}
