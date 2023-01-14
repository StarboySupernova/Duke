//
//  ExtensionOnView.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 4/16/22.
//

import Foundation
import SwiftUI

extension View {
    ///using the custom RoundedCorner Shape to render custom rounding on a view
    func customCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    /// returns screen size
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    /// Returns screen size as CGSize
    func getScreenSize() -> CGSize {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }

        return window.screen.bounds.size
    }
    
    //Safe Area Values
    func safeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
    
    func glow(color: Color = .red, radius: CGFloat = 20) -> some View {
        self
            .overlay(self.blur(radius: radius / 6))
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
    
    //Scrollview offset
    func offset(offset: Binding<CGFloat>) -> some View {
        return self
            .overlay {
                GeometryReader{ geometry in
                    let minY = geometry.frame(in: .named("SCROLL")).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                }
                .onPreferenceChange(OffsetKey.self) { value in
                    offset.wrappedValue = value
                }
            }
    }
    
    
    func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
        self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
    }
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct SectionHeader: View {
    let text: String
    var body: some View {
        Text(text)
            .padding()
            .frame(width: getRect().width, height: 28,alignment: .leading)
            .background(LinearGradient(mycolors: .black.opacity(0.2), .clear))
            .foregroundColor(Color.white)
    }
}

//To solve Binding<String> action tried to update multiple times per frame error
struct DelayedTextField: View {
    
    var title: String = ""
    var textContentType : UITextContentType
    @Binding var text: String
    @State private var tempText: String = ""
    
    var body: some View {
        TextField(title, text: $tempText, onEditingChanged: { editing in
            if !editing {
                $text.wrappedValue = tempText
            }
        })
        .textContentType(textContentType)
        .textInputAutocapitalization(.never)
        .onAppear {
            tempText = text
        }
    }
}




