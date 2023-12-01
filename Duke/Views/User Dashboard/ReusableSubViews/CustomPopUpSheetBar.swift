//
//  CustomTabBar.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 2/25/23.
//

import SwiftUI

struct CustomPopUpSheetBar: View {
    @State var symbolName: String = "questionmark.key.filled" //chnage this based  on sign-in status
    @State var action: () -> Void
    
    var backgroundColors: [Color] = [Color("purple"),Color("lightBlue"), Color(hex: "17203A")]
    var gradientCircle: [Color] = [Color("cyan"),Color("cyan").opacity(0.1), Color("cyan")]
    
    @State var bottomSheetPosition: BottomSheetPosition = .bottom
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue //changes deviating from original implementation have had no effect on the behaviour when inside HomeView
    @State var hasDragged: Bool = false
    @State var press: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue) //changes deviating from original implementation have had no effect on the behaviour when inside HomeView
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: Arc Shape
                Arc()
                    .fill(LinearGradient(colors: backgroundColors, startPoint: .leading, endPoint: .trailing))
                    .frame(height: getRect().height * 0.12)
                    .innerShadow(shape: Arc(), color: Color.bottomSheetBorderMiddle, lineWidth: 2, offsetX: 0, offsetY: 2, blur: 0, blendMode: .overlay, opacity: 1)
                    .overlay {
                        // MARK: Arc Border
                        Arc()
                            .stroke(Color.tabBarBorder, lineWidth: 0.9)
                    }
                    .overlay {
                        // MARK: Arc Border
                        Arc()
                            .stroke(colorScheme == .dark ? Color.tabBarBorder : Color.black, lineWidth: 0.5)
                    }
                    .innerShadow(shape: Arc(), color: Color.bottomSheetBorderMiddle, lineWidth: 2, offsetX: 0, offsetY: 2, blur: 0, blendMode: .overlay, opacity: 1)
                    .zIndex(-1)
                
                circleTabButton
                    .padding(.bottom, getRect().height * 0.075)
            }
            
            
        }
        .frame(height: getRect().height * 0.12)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    var circleTabButton: some View {
        Button {
            withAnimation(.easeInOut) {
                action()
            }
            
            withAnimation(.spring()) {
                press = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    press = false
                }
            }
            
        } label: {
            Image(systemName: symbolName)
                .renderingMode(.original)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .offset(y: -17)
                .opacity(0)
            #warning("come back and fix this opacity issue")
        }
        .scaleEffect(press ? 1.2 : 1)
        .background(Circle()
            .fill(.ultraThinMaterial)
            .frame(width: 50, height: 50)
            .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
            .offset(y: -17)
            .overlay(
                Circle()
                    .trim(from: 0, to: CGFloat(0.5))
                    .stroke(LinearGradient(colors: gradientCircle, startPoint: press ? .bottom : .top, endPoint: press ? .top : .bottom), style: StrokeStyle(lineWidth: 2))
                    .rotationEffect(.degrees(135))
                    .frame(width: 58, height: 58)
                    .offset(y: -17)
                    .scaleEffect(press ? 1.2 : 1)
                    .overlay(content: {
                        Image(systemName: "square.3.layers.3d.bottom.filled")
                            .renderingMode(.original)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .offset(y: -17)
                    })
            ), alignment: .trailing)
    }
}

struct CustomPopUpSheetBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomPopUpSheetBar(action: {})
            .preferredColorScheme(.dark)
    }
}
