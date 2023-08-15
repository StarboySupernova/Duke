//
//  NewParallaxView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 8/15/23.
//

import SwiftUI

struct NewParallaxView: View {
    @State var translation: CGSize = .zero
        @State var isDragging = false
        
        var body: some View {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                Image("background1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 600)
                    .overlay(
                        ZStack {
                            Image("logo1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 180)
                                .offset(x: translation.width/8, y: translation.height/15)
                            Image("logo2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 400)
                                .offset(x: translation.width/10, y: translation.height/20)
                            Image("logo3")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 392, height: 600)
                                .cornerRadius(50)
                                .blendMode(.overlay)
                                .offset(x: translation.width/15, y: translation.height/30)
                        }
                    )
                    .overlay(gloss1.blendMode(.softLight))
                    .overlay(
                        Image("gloss2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blendMode(.luminosity)
                            .mask(
                                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: translation.height/100, y: translation.height/100))
                                    .frame(width: 392)
                            )
                    )
                    .overlay(gloss2.blendMode(.overlay))
                    .overlay(
                        LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5086403146)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(translation.height)/10 - 10, y: abs(translation.height)/10 - 10))
                            .cornerRadius(50)
                    )
                    .overlay(
                        LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5086403146)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: translation.height/10, y: translation.height/10))
                            .cornerRadius(50)
                    )
                    .overlay(
                        // Outline
                        RoundedRectangle(cornerRadius: 50)
                            .strokeBorder(.linearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.740428394)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7562086093)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: translation.width/100 + 0.5, y: translation.height/100 + 0.5)))
                    )
                    .overlay {
                        LinearGradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 0.5152369619)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.4812706954))], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .blendMode(.overlay)
                            .cornerRadius(50)
                    }
                    .cornerRadius(50)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.black)
                            .opacity(0.5)
                            .blur(radius: 50)
                            .offset(y: 50)
                            .blendMode(.overlay)
                    )
                    .scaleEffect(0.9)
                    .rotation3DEffect(.degrees(isDragging ? 10 : 0), axis: (x: -translation.height, y: translation.width, z: 0))
                    .gesture(drag)
            }
        }
        
        var drag: some Gesture {
            DragGesture()
                .onChanged { value in
                    translation = value.translation
                    isDragging = true
                }
                .onEnded { value in
                    withAnimation {
                        translation = .zero
                        isDragging = false
                    }
                }
        }
        
    var gloss1: some View {
        Image("gloss1")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .mask(
                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(-translation.height)/100+1, y: abs(-translation.height)/100+1))
                    .frame(width: 392)
            )
    }
    
    var gloss2: some View {
        Image("gloss2")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .mask(
                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(translation.height)/100+1, y: abs(translation.height)/100+1))
                    .frame(width: 392)
            )
    }
}

struct NewParallaxView_Previews: PreviewProvider {
    static var previews: some View {
        NewParallaxView()
    }
}
