//
//  ShadowModifier.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/12/22.
//

import Foundation
import SwiftUI

struct ShadowModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
}
