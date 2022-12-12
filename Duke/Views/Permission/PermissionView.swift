//
//  ContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/2/22.
//

import SwiftUI

struct PermissionView: View {
    @State private var isAnimating: Bool = false
    let action : () -> Void
    
    var animation : Animation {
        .interpolatingSpring(stiffness: 0.5, damping: 0.5)
        .delay(isAnimating ? .random(in: 0...1) : 0)
        .speed(isAnimating ? .random(in: 0.3...1) : 0)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(1..<14) { index in
                        Image("food\(index % 7)")
                        //self positioning through geometry bounds
                            .position(x: .random(in: 0...geometry.size.width),
                                      y: .random(in: 0...geometry.size.height / 2)
                            )
                            .animation(animation, value: isAnimating)
                    }
                }
                .frame(height: geometry.size.height / 3)
                
                Text("Duke")
                    .font(.largeTitle)
                    .fontWeight(.ultraLight)
                    .padding(.bottom, .large)
                
                Text("Event Search Companion App")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    action()
                } label: {
                    Text(L10n.getStarted)
                        .bold()
                }
                .padding()
                .frame(width: geometry.size.width - 30)
                .background(Color.black)
                .cornerRadius(15)
                .shadow(radius: 10)
                .modifier(ShadowModifier())
                .foregroundColor(.white)
            }
        }
        .onAppear {
            isAnimating.toggle()
        }
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView() {}
    }
}
