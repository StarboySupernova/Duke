//
//  TabBar.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 4/25/23.
//

import SwiftUI

struct TabBar: View {
    var action: () -> Void
    
    var body: some View {
        ZStack {
            // MARK: Arc Shape
            Arc()
                .fill(Color.tabBarBackground)
                .frame(height: 88)
                .overlay {
                    // MARK: Arc Border
                    Arc()
                        .stroke(Color.tabBarBorder, lineWidth: 0.5)
                }
            
           
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
}


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(action: {}) //will need action to perform fullscreen covers
    }
}
