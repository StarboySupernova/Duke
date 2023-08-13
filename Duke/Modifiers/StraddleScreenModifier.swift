//
//  StraddleScreenModifier.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 8/13/23.
//

import Foundation
import SwiftUI

class StraddleScreen: ObservableObject {
    @Published var isStraddling: Bool = false
}

struct StraddleScreenModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .frame(width: geometry.size.width)
                .offset(x: -geometry.size.width / 2)
        }
    }
}

extension View {
    func straddleScreen() -> some View {
        self.modifier(StraddleScreenModifier())
    }
}
