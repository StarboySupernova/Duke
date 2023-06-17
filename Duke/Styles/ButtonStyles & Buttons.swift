//
//  ButtonStyles & Buttons.swift
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



struct SelectionButton: View {
    @State var buttonText: String
    
    @State var width: CGFloat = 50
    @State var height: CGFloat = 80
    
    @Binding var isSelected: Bool //will come from PreferenceStore variable
    @State var action: () -> Void = {}
    
    var currentBorderColors: [Color] = [Color("cyan"), Color("cyan").opacity(0), Color("cyan").opacity(0)]
    var currentGradient: [Color] = [Color("backgroundColor"), Color("grey")]
    
    var selectedBorderColors: [Color] = [Color("pink"), Color("pink").opacity(0), Color("pink").opacity(0)]
    var selectedGradient: [Color] = [Color("majenta"), Color("backgroundColor")]
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Text(buttonText)
                    .fontWeight(.bold)
            }
            .font(.subheadline)
            .foregroundColor(.white)
            .frame(width: width, height: height)
            .background(LinearGradient(colors: isSelected ? selectedGradient : currentGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(LinearGradient(colors: isSelected ? selectedBorderColors : currentBorderColors, startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 2))
                    .frame(width: width - 1, height: height - 1)
            }
        }
    }
}


struct TimeButton: View {
    @State var hour: String = "18:00"
    
    @State var width: CGFloat = 50
    @State var height: CGFloat = 40
    
    @Binding var isSelected: Bool
    @State var action: () -> Void = {}
    
    var currentBorderColors: [Color] = [Color("cyan"), Color("cyan").opacity(0), Color("cyan").opacity(0)]
    var currentGradient: [Color] = [Color("backgroundColor"), Color("grey")]
    
    var selectedBorderColors: [Color] = [Color("pink"), Color("pink").opacity(0), Color("pink").opacity(0)]
    var selectedGradient: [Color] = [Color("majenta"), Color("backgroundColor")]
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Text(hour)
            }
            .font(.subheadline)
            .foregroundColor(.white)
            .frame(width: width, height: height)
            .background(LinearGradient(colors: isSelected ? selectedGradient : currentGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(LinearGradient(colors: isSelected ? selectedBorderColors : currentBorderColors, startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 2))
                    .frame(width: width - 1, height: height - 1)
            }
        }
    }
}

struct CircleButton: View {
    @State var action: () ->Void
    @State var image: String = "arrow.left"
    
    var gradient: [Color] = [Color("cyan"),Color("cyan").opacity(0.1), Color("cyan")]
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: image)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial)
                .foregroundColor(.white)
                .cornerRadius(30)
                .overlay(
                    Circle()
                        .trim(from: 0, to: CGFloat(0.5))
                        .stroke(LinearGradient(colors: gradient, startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 2))
                        .rotationEffect(.degrees(135))
                        .frame(width: 42, height: 42)
                )
        }
    }
}


struct LargeButton: View {
    var selectedBorderColors: [Color] = [Color("pink"), Color("pink").opacity(0), Color("pink").opacity(0)]
    
    var body: some View {
        Text("Reservation")
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(LinearGradient(colors: [Color("majenta"), Color("purple")], startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(LinearGradient(colors: selectedBorderColors, startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 2))
                    .frame(maxWidth: .infinity, maxHeight: 58)
            }
    }
}

struct LargeButton_Previews: PreviewProvider {
    static var previews: some View {
        LargeButton()
            //.preferredColorScheme(.dark)
    }
}

struct RoundButton: View {
    @State var action: () -> Void = {}
    
    var gradientBorder: [Color] = [Color("cyan"),Color("cyan").opacity(0.1), Color("cyan")]

    var body: some View {
        Button {
            action()
        } label: {
            Text("Buy")
                .font(.subheadline)
                .frame(width: 70, height: 70)
                .background(.ultraThinMaterial)
                .cornerRadius(40)
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
                        .fill(.black.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .cornerRadius(40, corners: [.topLeft, .bottomLeft])
                )
        }
    }
}

struct RoundButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundButton()
    }
}



