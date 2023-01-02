//
//  LoadingView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show : Bool
    var body: some View {
        ZStack {
            if show {
                Group {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .padding(15)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: show)
    }
}
