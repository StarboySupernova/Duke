//
//  TextfieldIcon.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 10/26/23.
//

import SwiftUI

struct TextfieldIcon: View {
    var iconName: String
    @Binding var passedImage: UIImage?
    @Binding var currentlyEditing: Bool
    @State private var colorAngle = 180.0

    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .dark) {
                ZStack {
                    if currentlyEditing {
                        AngularGradient(gradient: Gradient(colors: [
                            Color(red: 101/255, green: 134/255, blue: 1),
                            Color(red: 1, green: 64/255, blue: 80/255),
                            Color(red: 109/255, green: 1, blue: 185/255),
                            Color(red: 39/255, green: 232/255, blue: 1),
                        ]), center: .center, angle: .degrees(colorAngle))
                        .blur(radius: 10)
                        .onAppear {
                            withAnimation(.linear(duration: 7)) {
                                self.colorAngle += 350
                            }
                        }
                    }
                }
                Color("tertiaryBackground")
                    .cornerRadius(12)
                    .opacity(0.8)
                    .blur(radius: 3.0)
            }
            .cornerRadius(12)
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .circular)
                        .stroke(Color.white, lineWidth: 1)
                        .blendMode(.overlay)
                    if passedImage != nil {
                        Image(uiImage: passedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: .large, height: .large)
                            .cornerRadius(8)
                    } else {
                        GradientIcon(iconName: iconName)
                    }
                }
            )
        }
        .frame(width: .xLarge, height: .xLarge)
        .padding([.vertical, .leading], 8)
    }
}

struct TextfieldIcon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TextfieldIcon(iconName: "key.fill", passedImage: .constant(UIImage(named: "Profile")!), currentlyEditing: .constant(false))
        }
    }
}
