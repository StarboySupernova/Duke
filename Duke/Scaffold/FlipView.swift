//
//  FlipView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/7/23.
//

import SwiftUI

struct FlipView: View {
    var business1: Business
    var business2: Business

    @State var show = false
    @State var viewState = CGSize.zero
    @State var appear = false

    var color1: Color = Color(red: 0.219, green: 0.008, blue: 0.855)
    var color2: Color = Color(red: 0.176, green: 0.012, blue: 0.561)

    var body: some View {
        content
    }

    var content: some View {
        ZStack {
            TrendingBusinessItem(business: business1, color1: color1, color2: color2, show: $show)
                .opacity(0.9)
                .rotation3DEffect(
                    Angle(degrees: show ? 90 : 0),
                    axis: (x: 1.0, y: 1.0, z: 0.0),
                    anchor: .center,
                    anchorZ: 0.0,
                    perspective: 0.3
                )
                .animation(
                    show ? .easeIn(duration: 0.3) : Animation.easeOut(duration: 0.3).delay(0.3)
                )

            TrendingBusinessItem(switchButtonText: "List", switchButtonImage: "list.bullet", business: business2, color1: Color(red: 0.365, green: 0.067, blue: 0.969), color2: Color(red: 0.961, green: 0.706, blue: 0.2), show: $show)
                .rotation3DEffect(
                    Angle(degrees: show ? 0 : -90),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .center,
                    anchorZ: 0.0,
                    perspective: 0.3
                )
                .animation(
                    show ? Animation.easeOut(duration: 0.3).delay(0.3) : .easeIn(duration: 0.3)
                )
        }
        .frame(maxWidth: 350)
        .animation(.easeInOut(duration: 0.8))
        .rotation3DEffect(
            Angle(degrees: appear ? 0 : 20),
            axis: (x: appear ? 0 : 1, y: appear ? 1 : 0, z: 0),
            anchor: .center,
            anchorZ: 0.0,
            perspective: 0.2
        )
        .animation(Animation.easeInOut(duration: 0.8))
        .onAppear {
            appear = true
        }
    }
}


struct FlipView_Previews: PreviewProvider {
    static var previews: some View {
        FlipView(business1: Business(alias: nil, categories: [.init(alias: nil, title: "Cafe")], coordinates: nil, displayPhone: nil, distance: nil, id: nil, imageURL: "https://loremflickr.com/g/620/440/paris", isClosed: nil, location: nil, name: "Blue bottle", phone: nil, price: nil, rating: 4.5, reviewCount: nil, transactions: nil, url: nil), business2: Business(alias: nil, categories: [.init(alias: nil, title: "SteakHouse")], coordinates: nil, displayPhone: nil, distance: nil, id: nil, imageURL: "https://loremflickr.com/g/620/440/paris", isClosed: nil, location: nil, name: "Avenue Gastronomic", phone: nil, price: nil, rating: 4.5, reviewCount: nil, transactions: nil, url: nil))
    }
}
