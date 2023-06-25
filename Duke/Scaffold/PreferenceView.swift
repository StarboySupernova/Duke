//
//  PreferenceView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/14/23.
//

import SwiftUI

struct PreferenceView: View {
    @State var animate: Bool = false
        
    @State var parallaxProperties: [ParallaxProperties] = [
        ParallaxProperties(headerText: "Cultural Preferences", buttonText: Array<String>(UserPreference.shared.collectBoolProperties().prefix(3)), imageName: "person.and.background.dotted"),
        ParallaxProperties(headerText: "Vegetarian Preferences", buttonText: Array<String>(UserPreference.shared.collectBoolProperties().dropFirst(3).prefix(3)), imageName: "leaf.circle.fill"),
        ParallaxProperties(headerText: "Seating Preferences", buttonText: Array<String>(UserPreference.shared.collectBoolProperties().dropFirst(6).prefix(3)), imageName: "wineglass"),
        ParallaxProperties(headerText: "Authentic Cuisine Preferences", buttonText: Array<String>(UserPreference.shared.collectBoolProperties().suffix(5)), imageName: "fork.knife"),
    ]
    
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
            
            ForEach(parallaxProperties) { prop in
                ParallaxView(headerText: prop.headerText, buttonText: prop.buttonText, imageName: prop.imageName)
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("backgroundColor"), Color("backgroundColor2")]), startPoint: .top, endPoint: .bottom)
        )
    }
    
    func buttonTextValues(_ index: Int) -> [String] {
        var buttonTextValues: [String] = []
        
        if index == 0 {
            // Attach functionality for the first headerText value
            // You can access `headerText` and `buttonTextValues` here and implement the desired functionality
            buttonTextValues = Array<String>(UserPreference.shared.collectBoolProperties().prefix(3))
        } else if index == 1 {
            // Attach functionality for the second headerText value
            // You can access `headerText` and `buttonTextValues` here and implement the desired functionality
            buttonTextValues = Array<String>(UserPreference.shared.collectBoolProperties().dropFirst(3).prefix(3))
        } else if index == 2 {
            // Attach functionality for the third headerText value
            // You can access `headerText` and `buttonTextValues` here and implement the desired functionality
            buttonTextValues = Array<String>(UserPreference.shared.collectBoolProperties().dropFirst(6).prefix(3))
        } else if index == 3{
            // Attach functionality for other headerText values
            // You can access `headerText` and `buttonTextValues` here and implement the desired functionality
            buttonTextValues = Array<String>(UserPreference.shared.collectBoolProperties().suffix(5))
        }
        
        return buttonTextValues
    }

}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
            .preferredColorScheme(.dark)
    }
}
