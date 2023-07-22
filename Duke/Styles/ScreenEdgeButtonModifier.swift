//
//  ScreenEdgeButtonModifier.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku 7/22/23.
//

import SwiftUI

struct ScreenEdgeButtonModifier: ViewModifier {
    var gradientBorder: [Color] = [Color("cyan"),Color("cyan").opacity(0.1), Color("cyan")]

    func body(content: Content) -> some View {
        content
            .overlay(
                Circle()
                    .trim(from: 0, to: CGFloat(0.5))
                    .stroke(LinearGradient(colors: gradientBorder, startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 2))
                    .rotationEffect(.degrees(135))
                    .frame(width: 68, height: 68)
            )
            .padding(.horizontal, 15)
            .background(
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .cornerRadius(40, corners: [.topLeft, .bottomLeft])
            )
        }
}

// Extension to apply the custom modifier to any View
extension View {
    func applyScreenEdgeButtonModifier() -> some View {
        self.modifier(ScreenEdgeButtonModifier())
    }
}

