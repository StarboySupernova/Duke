//
//  DetailView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/9/22.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var id: String
    @Binding var selectedBusiness: Business?
    @State var press = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Rectangle() //note to self - alignment has no effect when this is a Spacer
                    .fill(LinearGradient(gradient: Gradient(colors: [ColorConstants
                        .RedA200,ColorConstants.PinkA100]),startPoint: .topLeading, endPoint: .bottomTrailing))

                Map(coordinateRegion: $homeVM.region, annotationItems: homeVM.businessDetails != nil ? homeVM.businessDetails!.mapItems : []) {
                    MapMarker(coordinate: $0.coordinate, tint: .teal)
                }
                .frame(height: UIScreen.main.bounds.height * 0.45)
            }
            .overlay (
                homeVM.businessDetails != nil ? DetailCard(businessDetail: homeVM.businessDetails!) : nil,
                alignment: .bottom
            )
            .ignoresSafeArea(edges: [.top, .bottom])
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
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
                }
            })
            .onAppear {
                homeVM.requestDetails(forID: id)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: "WavvLdfdP6g8aZTtbBQHTw", selectedBusiness: .constant(nil)) //sample id from API docs
            .environmentObject(HomeViewModel())
    }
}

