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
    var currentGradient: [Color] = [Color("backgroundColor-1"), Color("grey")]
    
    var selectedBorderColors: [Color] = [Color("pink"), Color("pink").opacity(0), Color("pink").opacity(0)]
    var selectedGradient: [Color] = [Color("majenta"), Color("backgroundColor-1")]
    
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


struct CircleButton: View {
    @State var image: String = "arrow.left"
    @State var action: () ->Void
    
    var selectedBorderColors: [Color] = [Color("pink"), Color("pink").opacity(0), Color("pink").opacity(0)]

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: image)
                .frame(width: 44, height: 44)
                .foregroundColor(.white)
                .background(LinearGradient(colors: [Color("majenta"), Color("purple")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(30)
                .overlay(
                    Circle()
                        .trim(from: 0, to: CGFloat(0.5))
                        .stroke(LinearGradient(colors: selectedBorderColors, startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 2))
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
            .preferredColorScheme(.dark)
    }
}

///Must not pass more than one String parameter to this implementation
struct LargeSemiCircleButton: View {
    var text: String? = nil
    var sfImageName: String? = nil
    var imageName: String? = nil
    @State var action: () -> Void = {}
    
    var gradientBorder: [Color] = [Color("cyan"),Color("cyan").opacity(0.1), Color("cyan")]

    var body: some View {
        Button {
            action()
        } label: {
            if text != nil {
                Text(text!)
                    .font(.subheadline)
                    .frame(width: 70, height: 70)
                    .background(.ultraThinMaterial)
                    .cornerRadius(40)
                    .applyScreenEdgeButtonModifier()
            } else  if sfImageName != nil {
                Image(systemName: sfImageName!)
                    .font(.subheadline)
                    .frame(width: 70, height: 70)
                    .background(.ultraThinMaterial)
                    .cornerRadius(40)
                    .applyScreenEdgeButtonModifier()
            } else  if imageName != nil {
                Image(imageName!)
                    .font(.subheadline)
                    .frame(width: 70, height: 70)
                    .background(.ultraThinMaterial)
                    .cornerRadius(40)
                    .applyScreenEdgeButtonModifier()
            }
        }
    }
}

struct LargeSemiCircleButton_Previews: PreviewProvider {
    static var previews: some View {
        LargeSemiCircleButton(text: "Duke")
    }
}

@ViewBuilder
func iOS16Buttons(_ press: Binding<Bool>, action: @escaping () -> ()) -> some View {
    HStack(spacing: 30) {
        Button {
            withAnimation {
                action()
                //show.toggle()
            }
            withAnimation(.spring()) {
                press.wrappedValue = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    press.wrappedValue = false
                }
            }
        } label: {
            if #available(iOS 16.0, *) {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 64, height: 44)
                    .foregroundStyle(
                        .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
                        .shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
                        .shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
                    )
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
                    .overlay(Image(systemName: "list.bullet").foregroundStyle(.white))
            }
        }
        .scaleEffect(press.wrappedValue ? 1.2 : 1)
        
        if #available(iOS 16.0, *) {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 52, height: 52)
                .foregroundStyle(
                    .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
                    .shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
                    .shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
                )
                .overlay(
                    Circle()
                        .fill(.linearGradient(colors: [Color(#colorLiteral(red: 1, green: 0.7176470588, blue: 0.6980392157, alpha: 1)), Color(#colorLiteral(red: 0.7764705882, green: 0.3411764706, blue: 0.3098039216, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 32, height: 32)
                )
                .overlay(
                    Circle()
                        .stroke(.white, style: StrokeStyle(lineWidth: 1, dash: [1, 1]))
                        .frame(width: 22, height: 22)
                )
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
                .overlay(Image(systemName: "plus").foregroundStyle(.white))
        }
        
        if #available(iOS 16.0, *) {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 64, height: 44)
                .foregroundStyle(
                    .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
                    .shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
                    .shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
                )
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
                .overlay(Image(systemName: "location.north.circle.fill").foregroundStyle(.white))
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    .offset(y: -100)
}

struct FloatingButton: View {
    @State private var smallbuttonText: String = ""

    var body: some View {
        HStack {
            Spacer()
            Image("img_group_white_a700")
                .resizable()
                .frame(width: getRelativeWidth(20.0),
                       height: getRelativeHeight(18.0),
                       alignment: .center)
                .scaledToFit()
                .clipped()
                .padding(.vertical, getRelativeHeight(13.0))
                .padding(.leading, getRelativeWidth(14.0))
                .padding(.trailing, getRelativeWidth(10.0))
            TextField(StringConstants.kMsgMoreFigmaTuto,
                      text: $smallbuttonText)
            .font(FontScheme
                .kRobotoCondensedRegular(size: getRelativeHeight(15.0)))
            .foregroundColor(ColorConstants.WhiteA700)
            .padding()
        }
        .frame(width: getRelativeWidth(220.0),
               height: getRelativeHeight(44.0), alignment: .center)
        .overlay(RoundedCorners(topLeft: 22.0, topRight: 22.0,
                                bottomLeft: 22.0, bottomRight: 22.0)
            .stroke(ColorConstants.Black9004c,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 22.0, topRight: 22.0,
                                   bottomLeft: 22.0, bottomRight: 22.0)
            .fill(LinearGradient(gradient: Gradient(colors: [ColorConstants
                .Bluegray9007f,
                                                             ColorConstants
                .Bluegray9007f]),
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing)))
        .shadow(color: ColorConstants.Black90026, radius: 40, x: 0,
                y: 20)
        .padding(.top, getRelativeHeight(12.0))
        .padding(.horizontal, getRelativeWidth(48.0))
    }
}

struct SelectionButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectionButton(buttonText: "Test Button", isSelected: .constant(false))
            .preferredColorScheme(.dark)
        iOS16Buttons(.constant(false), action: {})
            .preferredColorScheme(.dark)
        CircleButton(action: {})
            .preferredColorScheme(.dark)
        TimeButton(isSelected: .constant(false))
            .preferredColorScheme(.dark)
    }
}

@ViewBuilder func StandardBackButton(action: () -> Void) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        Button {
            
        } label: {
            Label {
                Text("Back")
                    .fontWeight(.semibold)
            } icon: {
                Image(systemName: "chevron.left")
                    .font(.title2.bold())
            }
            .foregroundColor(.primary)
        }
    }
    .frame(width: .infinity, alignment: .leading)
    .padding()
}





