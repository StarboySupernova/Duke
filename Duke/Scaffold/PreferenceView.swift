//
//  PreferenceView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/14/23.
//

import SwiftUI

struct PreferenceView: View {
    @StateObject private var preferenceStore: UserPreference = UserPreference()
    @State var animate: Bool = false
    
    var body: some View {
        ZStack {
            CircleBackground(color: Color("greenCircle"))
                .blur(radius: animate ? 30 : 100)
                .offset(x: animate ? -50 : -130, y: animate ? -30 : -100)
                .task {
                    withAnimation(.easeInOut(duration: 7).repeatCount(1, autoreverses: true)) {
                        animate.toggle()
                    }
                }
            
            CircleBackground(color: Color("pinkCircle"))
                .blur(radius: animate ? 30 : 100)
                .offset(x: animate ? 100 : 130, y: animate ? 150 : 100)
                .task {
                    withAnimation(.easeInOut(duration: 4).repeatCount(1, autoreverses: true)) {
                        animate.toggle()
                    }
                }
            
            SelectionView()
                .environmentObject(preferenceStore)
        }
        .background (
            LinearGradient(gradient: Gradient(colors: [Color("backgroundColor-1"), Color("backgroundColor2")]), startPoint: .top, endPoint: .bottom)
        )
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
            .preferredColorScheme(.dark)
    }
}
