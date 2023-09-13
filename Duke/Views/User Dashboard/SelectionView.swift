//
//  SelectionView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 6/27/23.
//

import SwiftUI

//modify this since ExtenstionOnUserDedaults causes a fatal error here

struct SelectionView: View {
    //here singleton pattern on UserPreference is used only inside initialization of @State property
    @State var parallaxProperties: [ParallaxProperties] = [
        ParallaxProperties(headerText: "Cultural Preferences", buttonText: Array<String>(UserPreference.shared.collectBoolProperties().prefix(3)), imageName: "person.and.background.dotted"),
        ParallaxProperties(headerText: "Vegetarian Preferences", buttonText: Array<String>(UserPreference.shared.collectBoolProperties().dropFirst(3).prefix(3)), imageName: "leaf.circle.fill"),
        ParallaxProperties(headerText: "Seating Preferences", buttonText: Array<String>(UserPreference.shared.collectBoolProperties().dropFirst(6).prefix(3)), imageName: "wineglass"),
        ParallaxProperties(headerText: "Authentic Cuisine Preferences", buttonText: Array<String>(UserPreference.shared.collectBoolProperties().suffix(5)), imageName: "fork.knife"),
    ]
    
    var body: some View {
        ZStack {
            ForEach(parallaxProperties.reversed()) { prop in
                ParallaxView(parallaxProperties: $parallaxProperties, headerText: prop.headerText, buttonText: prop.buttonText, imageName: prop.imageName)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView()
            .environmentObject(UserPreference())
            .preferredColorScheme(.dark)
    }
}
