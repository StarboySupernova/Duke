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
    @Binding var selectedBusiness: Business?
    @State var press = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle() //note to self - alignment has no effect when this is a Spacer
                .fill(LinearGradient(gradient: Gradient(colors: [ColorConstants
                    .RedA200,ColorConstants.PinkA100]),startPoint: .topLeading, endPoint: .bottomTrailing))

            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.businessDetails != nil ? viewModel.businessDetails!.mapItems : []) {
                MapMarker(coordinate: $0.coordinate, tint: .teal)
            }
            .frame(height: UIScreen.main.bounds.height * 0.45)
        }
        .overlay (
            viewModel.businessDetails != nil ? DetailCard(businessDetail: viewModel.businessDetails!) : nil,
            alignment: .bottom
        )
        .overlay(alignment: .topLeading, content: {
            CircleButton {
                withAnimation {
                    selectedBusiness = nil
                }
                withAnimation(.spring()) {
                    press = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        press = false
                    }
                }
            }
            .scaleEffect(press ? 1.2 : 1)
            .padding(.top, .xxLarge)
            .padding(.leading, .medium)
        })
        .ignoresSafeArea(edges: [.top, .bottom])
        .onAppear {
            viewModel.requestDetails(forID: id)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: "WavvLdfdP6g8aZTtbBQHTw", selectedBusiness: .constant(nil)) //sample id from API docs
            .environmentObject(HomeViewModel())
    }
}

