//
//  FavouritesContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/18/23.
//

import SwiftUI

struct FavouritesContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            FavouritesHome(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .vertical)
        }
    }
}

struct FavouritesContentView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesContentView()
    }
}
