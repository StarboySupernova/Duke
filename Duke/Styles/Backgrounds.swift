//
//  Backgrounds.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 11/17/22.
//

import Foundation
import SwiftUI

struct ColorfulBackground<S: Shape>: View {
    var isHighlighted: Bool //is it depressed or not
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(mycolors: Color.lightEnd, Color.lightStart))
                    .overlay(shape.stroke(LinearGradient(mycolors: Color.lightStart, Color.lightEnd), lineWidth: 4)) //bevel appears when button is pressed
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(mycolors: Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(LinearGradient(mycolors: Color.lightStart, Color.lightEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 5, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 5, x: 10, y: 10)
            }
        }
    }
}

struct ColourBackground<S: Shape>: View {
    var isHighlighted: Bool //is it depressed or not
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(mycolors: Color.lightEnd, Color.lightStart))
                    .overlay(shape.stroke(LinearGradient(mycolors: Color.lightStart, Color.lightEnd), lineWidth: 1)) //bevel appears when button is pressed
            } else {
                shape
                    .fill(LinearGradient(mycolors: Color.black, Color.darkEnd))
                    .overlay(shape.stroke(LinearGradient(mycolors: Color.white, Color.offWhite), lineWidth: 1))
            }
        }
    }
}

