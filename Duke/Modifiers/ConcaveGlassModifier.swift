//
//  ConcaveGlassModifier.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 5/13/22.
//

import Foundation
import SwiftUI

struct ConcaveGlassViewWithOverlay: ViewModifier {
    /*
     Same modifiers as ConvexGlassView, flipping only the order of the LinearGradient Color and making shadow opacity higher for a crispier look
     */
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .overlay(
                LinearGradient(colors: [.black.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
            .cornerRadius(14)
            .shadow(color: .white.opacity(0.9), radius: 2, x: -1, y: -2)
            .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
    }
}

/*
 Another way of doing this is to add two overlaying shapes. In our case, we are using two rounded rectangles with the same cornerRadius. The first RoundedRectangle gives us a white and black shadow effect that will give us depth. We need the black shadow at the top and the white shadow at the bottom. Don’t forget to keep this overlay above the corner radius modifier to keep the edges sharp.

 The second overlaid rounded rectangle will give you more depth. Add a radial gradient with clear and transparent black colors. The radial gradient will create a shadow effect on one side of the view (top and left) giving it more depth.
 */

struct ConcaveGlassView: ViewModifier {
    func body(content: Content) -> some View {
            content
                .padding()
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.linearGradient(colors:[.black,.white.opacity(0.75)], startPoint: .top, endPoint: .bottom), lineWidth: 2)
                        .blur(radius: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.radialGradient(Gradient(colors: [.clear,.black.opacity(0.1)]), center: .bottomLeading, startRadius: 300, endRadius: 0), lineWidth: 15)
                        .offset(y: 5)
                )
                .cornerRadius(14)
    }
}

struct CompactConcaveGlassView: ViewModifier {
    func body(content: Content) -> some View {
            content
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.linearGradient(colors:[.black,.white.opacity(0.75)], startPoint: .top, endPoint: .bottom), lineWidth: 2)
                        .blur(radius: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.radialGradient(Gradient(colors: [.clear,.black.opacity(0.1)]), center: .bottomLeading, startRadius: 300, endRadius: 0), lineWidth: 15)
                        .offset(y: 5)
                )
                .cornerRadius(14)
    }
}


