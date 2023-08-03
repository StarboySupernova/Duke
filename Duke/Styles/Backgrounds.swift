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

struct DarkBackground: View {
    @ObservedObject var manager = MotionManager()
    @State var translation: CGSize = .zero
    @State var location: CGPoint = .zero
    @State var isDragging = false
    @State var offset = 0.0
    @Binding var show: Bool

    var body: some View {
        ZStack {
            background
            outerCircles
                .frame(width: 393)
            innerCircles
                .frame(width: 393)
                .overlay(flashlight)
            waypoints
                .rotationEffect(Angle(degrees: 0.0))
                .scaleEffect(show ? 0.9 : 1)
            circleLabel
                .rotation3DEffect(.degrees(show ? 10 : 0), axis: (x: 1, y: 0, z: 0))
            strokes
                .rotation3DEffect(.degrees(show ? 10 : 0), axis: (x: 1, y: 0, z: 0))
        }
        .gesture(drag)
    }
    
    var flashlight: some View {
        ZStack {
            Circle()
                .fill(.radialGradient(colors: [.white.opacity(0.1), .clear], center: .center, startRadius: 0, endRadius: 200))
                .offset(x: location.x-200, y: location.y-380)
                .opacity(isDragging ? 1 : 0)
            
            Circle()
                .fill(.radialGradient(colors: [.white.opacity(1), .clear], center: .center, startRadius: 0, endRadius: 200))
                .offset(x: location.x-200, y: location.y-380)
                .opacity(isDragging ? 1 : 0)
                .mask(
                    ZStack {
                        Circle()
                            .stroke()
                            .scaleEffect(1.2)
                        Circle()
                            .stroke()
                            .scaleEffect(1.5)
                        Circle()
                            .stroke()
                            .padding(20)
                        Circle()
                            .stroke()
                            .padding(80)
                        Circle()
                            .stroke()
                            .padding(100)
                        Circle()
                            .stroke()
                            .padding(120)
                        Circle()
                            .stroke()
                            .padding(145)
                        Circle()
                            .stroke()
                            .padding(170)
                                                
                        ZStack {
                            Text("N")
                                .offset(x: 0, y: -135)
                            Text("E")
                                .rotationEffect(.degrees(90))
                                .offset(x: 135, y: 0)
                            Text("S")
                                .rotationEffect(.degrees(180))
                                .offset(x: 0, y: 135)
                            Text("W")
                                .rotationEffect(.degrees(270))
                                .offset(x: -135, y: 0)
                        }
                    }
                        .rotationEffect(Angle(degrees: 0.0))
                )
        }
        .opacity(show ? 0 : 1)
    }
    
    
    var background: some View {
        Rectangle()
            .fill(.radialGradient(colors: [Color(#colorLiteral(red: 0.2970857024, green: 0.3072845936, blue: 0.4444797039, alpha: 1)), .black], center: .center, startRadius: 1, endRadius: 400))
            .ignoresSafeArea()
    }
    
    var circleLabel: some View {
        CircleLabelView(radius: 135, text: "• DUKE •".uppercased(), kerning: 3, size: CGSize(width: 225, height: 225))
            .foregroundStyle(.white)
            .font(.system(size: 12, weight: .bold, design: .monospaced))
    }
        
    var strokes: some View {
        ZStack {
            Circle()
                .strokeBorder(gradient, style: StrokeStyle(lineWidth: 5, dash: [1, 1]))
            
        }
        .frame(width: 315, height: 315)
    }
    
    var light: some View {
        Circle()
            .trim(from: 0.6, to: 0.9)
            .stroke(.radialGradient(colors: [.white.opacity(0.2), .white.opacity(0)], center: .center, startRadius: 0, endRadius: 200), style: StrokeStyle(lineWidth: 200))
            .frame(width: 200, height: 200)
    }
    
    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(#colorLiteral(red: 0.61807781457901, green: 0.6255635619163513, blue: 0.7079070806503296, alpha: 1)), location: 0),
                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 1)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
    
    var outerCircles: some View {
        ZStack {
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .scaleEffect(show ? 1.5 : 1.2)
            .rotation3DEffect(.degrees(show ? 25 : 0), axis: (x: 1, y: 0, z: 0))
            
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .scaleEffect(show ? 2 : 1.5)
                .rotation3DEffect(.degrees(show ? 30 : 0), axis: (x: 1, y: 0, z: 0))
        }
    }
    
    var innerCircles: some View {
        ZStack {
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [Color(#colorLiteral(red: 0.03137254902, green: 0.0431372549, blue: 0.06666666667, alpha: 1)), Color(#colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.3254901961, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .padding(20)
            
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [Color(#colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1529411765, alpha: 1)), Color(#colorLiteral(red: 0.06666666667, green: 0.07058823529, blue: 0.137254902, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .padding(80)
            
            Circle()
                .foregroundStyle(
                    .radialGradient(colors: [Color(#colorLiteral(red: 0.03921568627, green: 0.0431372549, blue: 0.1215686275, alpha: 1)), Color(#colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.3215686275, alpha: 1))], center: .center, startRadius: 0, endRadius: 100)
                )
                .padding(100)
            
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .padding(120)
            
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .padding(145)
            
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .padding(170)
            
            Circle()
                .foregroundStyle(.white)
                .padding(188)
        }
        .rotation3DEffect(.degrees(show ? 15 : 0), axis: (x: 1, y: 0, z: 0))
    }
    
    var waypoints: some View {
        ZStack {
            Circle()
                .fill(.blue)
                .frame(width: 16, height: 16)
                .offset(x: 100, y: 250)
            
            Circle()
                .fill(.red)
                .frame(width: 16, height: 16)
                .offset(x: -120, y: -200)
            
            Circle()
                .fill(.green)
                .frame(width: 16, height: 16)
                .offset(x: 100, y: -150)
        }
    }

    var sheet: some View {
        OldCompassSheet(degrees: .constant(0.0), show: $show)
            .background(.black.opacity(0.5))
            .background(.ultraThinMaterial)
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white.opacity(0.2))
                    .frame(width: 40, height: 5)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .offset(y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .strokeBorder(.linearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .offset(y: show ? 340+offset : 1000)
            .offset(y: translation.height)
            .gesture(dragSheet)
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                location = value.location
                isDragging = true
            }
            .onEnded { value in
                withAnimation {
                    translation = .zero
                    isDragging = false
                }
            }
    }
    
    var dragSheet: some Gesture {
        DragGesture()
            .onChanged { value in
                translation = value.translation
            }
            .onEnded { value in
                withAnimation {
                    let offsetY = translation.height
                    
                    if offsetY > 150-offset {
                        show.toggle()
                    }
                    
                    if offsetY < -100-offset {
                        offset = -280
                    } else {
                        offset = 0
                    }
                    
                    translation = .zero
                }
            }
    }
}

struct DarkBackground_Previews: PreviewProvider {
    static var previews: some View {
        DarkBackground(show: .constant(true))
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


 ///////////////////////////////////////////////////////

enum BottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.9 // 0.83 - 702/844
    case middle = 0.01 //0.385 - 325/844
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








