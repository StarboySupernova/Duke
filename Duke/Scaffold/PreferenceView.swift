//
//  PreferenceView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/14/23.
//

import SwiftUI

struct PreferenceView: View {
    @StateObject var preferenceStore: UserPreference = UserPreference(headerText: ["Cultural Preferences", "Vegetarian Preferences", "Seating Preferences", "Authentic Cuisine Preferences"], buttonText: ["Halaal", "Haram", "Pork", "Vegan", "Vegetarian", "Containing-Lactose", "Outdoor seating", "Recommend Wine Farms?","Wine-Tasting"], imageName: ["person.and.background.dotted","leaf.circle.fill", "wineglass", "fork.knife"]) //default values
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
            
            ForEach(preferenceStore.headerText.indices, id: \.self) { index in
                let headerText = preferenceStore.headerText[index]
                let imageName = preferenceStore.imageName[index]
                
                switch index {
                case 0:
                    // Attach functionality for the first headerText value
                    // You can access `headerText` and `buttonTextValues` here and implement the desired functionality
                    let buttonTextValues = Array<String>(preferenceStore.collectBoolProperties().prefix(3))
                    ParallaxView(preference: preferenceStore, headerText: headerText, buttonText: buttonTextValues, imageName: imageName)
                    
                case 1:
                    // Attach functionality for the second headerText value
                    // You can access `headerText` and `buttonTextValues` here and implement the desired functionality
                    let buttonTextValues = Array<String>(preferenceStore.collectBoolProperties().dropFirst(3).prefix(3))
                    ParallaxView(preference: preferenceStore, headerText: headerText, buttonText: buttonTextValues, imageName: imageName)
                    
                case 2:
                    // Attach functionality for the third headerText value
                    // You can access `headerText` and `buttonTextValues` here and implement the desired functionality
                    let buttonTextValues = Array<String>(preferenceStore.collectBoolProperties().dropFirst(6).prefix(3))
                    ParallaxView(preference: preferenceStore, headerText: headerText, buttonText: buttonTextValues, imageName: imageName)

                default:
                    // Attach functionality for other headerText values
                    // You can access `headerText` and `buttonTextValues` here and implement the desired functionality
                    let buttonTextValues = Array<String>(preferenceStore.collectBoolProperties().suffix(5))
                    ParallaxView(preference: preferenceStore, headerText: headerText, buttonText: buttonTextValues, imageName: imageName)

                }
            }

        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("backgroundColor"), Color("backgroundColor2")]), startPoint: .top, endPoint: .bottom)
        )
        
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
            .preferredColorScheme(.dark)
    }
}
