//
//  FlatGlassModifier.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 5/13/22.
//

import Foundation
import SwiftUI

struct FlatGlassView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(14)
        /*
         recommended modifiers on containing view
            .background(.ultraThinMaterial)
            .foregroundColor(Color.primary.opacity(0.35)
            .foregroundStyle(.ultraThinMaterial)
         */
    }
}
