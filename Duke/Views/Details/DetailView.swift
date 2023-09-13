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
        .overlay(alignment: .topLeading, content: {
            backButton
        })
        .ignoresSafeArea(edges: [.top, .bottom])
        .onAppear {
            viewModel.requestDetails(forID: id)
        }
    }
    
    var backButton: some View {
        Button {
            withAnimation {
                selectedBusiness = nil
            }
            withAnimation(.spring()) {
                press = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    press = false
                }
            }
        } label: {
            if #available(iOS 16.0, *) {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 64, height: 44)
                    .foregroundStyle(
                        .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
                        .shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
                        .shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
                    )
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
                    .overlay(Image(systemName: "arrowshape.turn.up.backward.fill").foregroundStyle(.white))
                    .padding(.small)
            } else {
                // Fallback on earlier versions
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 64, height: 44)
                    .foregroundStyle(
                        .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
                    .overlay(Image(systemName: "arrowshape.turn.up.backward.fill").foregroundStyle(.white))
                    .padding(.small)
            }
        }
        .scaleEffect(press ? 1.2 : 1)
        .padding(.medium)
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: "WavvLdfdP6g8aZTtbBQHTw", selectedBusiness: .constant(nil)) //sample id from API docs
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}

