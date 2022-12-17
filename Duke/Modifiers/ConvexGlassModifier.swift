//
//  ConvexGlassModifier.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 5/13/22.
//

import Foundation
import SwiftUI

/*
 To give a protruding look to the UI, we will need to add some shadows to our view modifier. We add white and black shadows to the view modifier and lower their opacity value. Position the shadows opposite of each other
 To make the modified view protrude more, overlay a LinearGradient on top of it. Keep the overlay before the cornerRadius so that it can have the same corners as our modified view.
 */

struct ConvexGlassView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .overlay(LinearGradient(colors: [.clear,.black.opacity(0.2)], startPoint: .top, endPoint: .bottom))
            .cornerRadius(14)
            .shadow(color: .white.opacity(0.65), radius: 1, x: -1, y: -2)
            .shadow(color: .black.opacity(0.65), radius: 2, x: 2, y: 2)
        
        /*
         recommended modifiers on containing view
            .background(.ultraThinMaterial)
            .foregroundColor(Color.primary.opacity(0.35)
            .foregroundStyle(.ultraThinMaterial)
         */

    }
}

struct CompactConvexGlassView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .overlay(LinearGradient(colors: [.clear,.black.opacity(0.2)], startPoint: .top, endPoint: .bottom))
            .cornerRadius(14)
            .shadow(color: .white.opacity(0.65), radius: 1, x: -1, y: -2)
            .shadow(color: .black.opacity(0.65), radius: 2, x: 2, y: 2)
        
        /*
         recommended modifiers on containing view
            .background(.ultraThinMaterial)
            .foregroundColor(Color.primary.opacity(0.35)
            .foregroundStyle(.ultraThinMaterial)
         */

    }
}
