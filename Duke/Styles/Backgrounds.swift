//
//  Backgrounds.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 11/17/22.
//

import Foundation
import SwiftUI
import BottomSheet

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
                    .overlay(shape.stroke(LinearGradient(mycolors: Color.pink, Color.lightEnd), lineWidth: 4))
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

struct CircleBackground: View {
    @State var color: Color = Color("greenCircle")
    
    var body: some View {
        Circle()
            .frame(width: 300, height: 300)
            .foregroundColor(color)
    }
}

var mainBackground: some View {
    Rectangle()
        .fill(.radialGradient(colors: [Color(#colorLiteral(red: 0.2970857024, green: 0.3072845936, blue: 0.4444797039, alpha: 1)), .black], center: .center, startRadius: 1, endRadius: 400))
        .ignoresSafeArea()
}

var lightBackground: some View {
    /// to be used when the view has no need for sheet
    ZStack {
        // MARK: Background Color
        Color.background
            .ignoresSafeArea()
        
        // MARK: Background Image
        Image("Background")
            .resizable()
            .ignoresSafeArea()
            .opacity(0.1)
    }
}

class UIBackdropView: UIView {
    override class var layerClass: AnyClass {
        NSClassFromString("CABackdropLayer") ?? CALayer.self
    }
}

struct Backdrop: UIViewRepresentable {
    func makeUIView(context: Context) -> UIBackdropView {
        UIBackdropView()
    }
    
    func updateUIView(_ uiView: UIBackdropView, context: Context) {}
}

struct Blur: View {
    var radius: CGFloat = 3
    var opaque: Bool = false
    
    var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
    }
}

extension Color {
    static let background = LinearGradient(gradient: Gradient(colors: [Color("Background 1"), Color("gradient-bottom")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let bottomSheetBackground = LinearGradient(gradient: Gradient(colors: [Color("Background 1").opacity(0.26), Color("Background 2").opacity(0.26)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let navBarBackground = LinearGradient(gradient: Gradient(colors: [Color("Background 1").opacity(0.1), Color("Background 2").opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let tabBarBackground = LinearGradient(gradient: Gradient(colors: [Color("Tab Bar Background 1").opacity(0.26), Color("Tab Bar Background 2").opacity(0.26)]), startPoint: .top, endPoint: .bottom)
    static let weatherWidgetBackground = LinearGradient(gradient: Gradient(colors: [Color("Weather Widget Background 1"), Color("Weather Widget Background 2")]), startPoint: .leading, endPoint: .trailing)
    static let bottomSheetBorderMiddle = LinearGradient(gradient: Gradient(stops: [.init(color: .white, location: 0), .init(color: .clear, location: 0.2)]), startPoint: .top, endPoint: .bottom)
    static let bottomSheetBorderTop = LinearGradient(gradient: Gradient(colors: [.white.opacity(0), .white.opacity(0.5), .white.opacity(0)]), startPoint: .leading, endPoint: .trailing)
    static let underline = LinearGradient(gradient: Gradient(colors: [.white.opacity(0), .white, .white.opacity(0)]), startPoint: .leading, endPoint: .trailing)
    static let tabBarBorder = Color("Tab Bar Border").opacity(0.5)
    static let forecastCardBackground = Color("Forecast Card Background")
    static let probabilityText = Color("Probability Text")
}

extension View {
    func backgroundBlur(radius: CGFloat = 3, opaque: Bool = false) -> some View {
        self
            .background(
                Blur(radius: radius, opaque: opaque)
            )
    }
}

extension View {
    func innerShadow<S: Shape, SS: ShapeStyle>(shape: S, color: SS, lineWidth: CGFloat = 1, offsetX: CGFloat = 0, offsetY: CGFloat = 0, blur: CGFloat = 4, blendMode: BlendMode = .normal, opacity: Double = 1) -> some View {
        return self
            .overlay {
                shape
                    .stroke(color, lineWidth: lineWidth)
                    .blendMode(blendMode)
                    .offset(x: offsetX, y: offsetY)
                    .blur(radius: blur)
                    .mask(shape)
                    .opacity(opacity)
            }
    }
}


 ///////////////////////////////////////////////////////

enum BottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.83 // 702/844
    case middle = 0.385 // 325/844
    case bottom = 0.0
}

enum Weather {
    case sunny(Double)
    case rainy(Double)
    case cloudy(Double)

    var chanceOfRain: Double {
        switch self {
        case .sunny(let humidity):
            return humidity * 0.1
        case .rainy(let humidity):
            return humidity * 0.9
        case .cloudy(let humidity):
            return humidity * 0.3
        }
    }
}

let sunnyWeather = Weather.sunny(0.5)
//print(sunnyWeather.chanceOfRain) // Output: 0.05








