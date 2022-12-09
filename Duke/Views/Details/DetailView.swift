//
//  DetailView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/9/22.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var id: String

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle() //note to self - alignment has no effect when this is a Spacer
                .fill(Color.teal.opacity(0.1))
            
            Map(coordinateRegion: $viewModel.region)
                .frame(height: UIScreen.main.bounds.height * 0.45)
        }
        .overlay (
            Rectangle()
                .fill(Color.mint)
                .frame(height: UIScreen.main.bounds.height * 0.55, alignment: .bottom)
                .cornerRadius(20),
        alignment: .bottom
        )
        .ignoresSafeArea(edges: .top)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: "QPOI0dYeAl3U8iPM_IYWnA")
            .environmentObject(HomeViewModel())
    }
}
