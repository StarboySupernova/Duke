//
//  ButtonStyles.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 10/16/22.
//

import Foundation
import SwiftUI

//Scaled ButtonStyle
struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

struct ColorfulButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .contentShape(Circle())
            .background(
                ColorfulBackground(isHighlighted: configuration.isPressed, shape: Circle())
            )
    }
}

struct CapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.medium)
            .padding(.horizontal, .small)
            .contentShape(Capsule())
            .background(
                ColourBackground(isHighlighted: configuration.isPressed, shape: Capsule())
            )
    }
}

