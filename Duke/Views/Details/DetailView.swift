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
            
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.businessDetails != nil ? viewModel.businessDetails!.mapItems : []) {
                MapMarker(coordinate: $0.coordinate, tint: .teal)
            }
                .frame(height: UIScreen.main.bounds.height * 0.45)
        }
        .overlay (
            viewModel.businessDetails != nil ? DetailCard(businessDetail: viewModel.businessDetails!) : nil,
        alignment: .bottom
        )
        .ignoresSafeArea(edges: [.top, .bottom])
        .onAppear {
            viewModel.requestDetails(forID: id)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: "WavvLdfdP6g8aZTtbBQHTw")
            .environmentObject(HomeViewModel())
    }
}
