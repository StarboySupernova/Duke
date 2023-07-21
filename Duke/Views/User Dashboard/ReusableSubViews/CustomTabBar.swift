//
//  CustomTabBar.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 2/25/23.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var currentTab: SideMenuTab
    var action: () -> Void
    
    var backgroundColors: [Color] = [Color("purple"),Color("lightBlue"), Color("pink")]
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
            //let width = geometry.size.width
            //let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
            
            ZStack {
                // MARK: Arc Shape
                #warning("give frame getRect * 0.1, then set .bottom to be getRect * 0.1")
                Arc()
                    .fill(LinearGradient(colors: backgroundColors, startPoint: .leading, endPoint: .trailing))
                    .frame(height: getRect().height * 0.1)
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
                    .zIndex(-1)
                
                HStack(spacing: 0.0) {
                    ForEach(SideMenuTab.allCases, id: \.rawValue) { tab in
                        HStack(spacing: 0.0) {
                            Button {
                                withAnimation(.easeInOut) {
                                    currentTab = tab
                                    action()
                                }
                                
                                withAnimation(.spring()) {
                                    press = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        press = false
                                    }
                                }
                            } label: {
                                Image(systemName: tab.rawValue)
                                    .renderingMode(.original)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .offset(y: -17)
                            }
                            .scaleEffect(press ? 1.2 : 1)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 80, height: 80)
                            .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                            .offset(y: -17)
                            .overlay(
                                Circle()
                                    .trim(from: 0, to: CGFloat(0.5))
                                    .stroke(LinearGradient(colors: gradientCircle, startPoint: press ? .bottom : .top, endPoint: press ? .top : .bottom), style: StrokeStyle(lineWidth: 2))
                                    .rotationEffect(.degrees(135))
                                    .frame(width: 78, height: 78)
                                    .offset(y: -17)
                                    .scaleEffect(press ? 1.2 : 1)
                            ), alignment: .center)
                    }
                    
                }
                .innerShadow(shape: Arc(), color: Color.bottomSheetBorderMiddle, lineWidth: 2, offsetX: 0, offsetY: 2, blur: 0, blendMode: .overlay, opacity: 1)
                
            }
            .frame(height: getRect().height * 0.1)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(currentTab: .constant(.home), action: {})
            .preferredColorScheme(.dark)
    }
}


