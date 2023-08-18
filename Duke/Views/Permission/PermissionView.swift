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
//                    ForEach(1..<14, id: \.self) { index in
//                        Image("food\(index % 7)")
//                        //self positioning through geometry bounds
//                            .position(x: .random(in: 0...geometry.size.width),
//                                      y: .random(in: 0...geometry.size.height / 2)
//                            )
//                            .animation(animation, value: isAnimating)
//                    }

                }
                .frame(height: geometry.size.height / 3)
                
                Spacer()
                
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
                .frame(width: geometry.size.width * 0.7)
//                .background(colorScheme == .light ? Color.black : Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .foregroundColor(Color.white)
                .modifier(ConvexGlassView())
                
                Spacer()
            }
            .frame(maxWidth: getRect().width * 0.95)
        }
        .background(
            ZStack {
                Image("background3")
                    .resizedToFill(width: getRect().width, height: getRect().height)
                
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(width: getRect().width * 0.99, height: getRect().height * 0.98)
                    .cornerRadius(100, corners: [.topRight])
                    .cornerRadius(20, corners: [.topLeft, .bottomLeft, .bottomRight])
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
            .preferredColorScheme(.dark)
    }
}
