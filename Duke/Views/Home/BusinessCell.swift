//
//  BusinessCell.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/8/22.
//

import SwiftUI
import ExtensionKit

struct BusinessCell: View {
    let business: Business
    
    var body: some View {
        HStack{
            AsyncImage(url: business.formattedImageURL) { image in
                image
                    .resizable()
            } placeholder: {
                Color.blue.shimmer() //remove shimmer in prod
            }
            .frame(width: 110, height: 110)
            .cornerRadius(10)
            .padding(.small)
            
            //Labels
            VStack(alignment: .leading, spacing: .small) {
                Text(business.formattedName)
                Text(business.formattedCategory)
                HStack {
                    Text(business.formattedRating)
                    Image("star")
                }
            }
            
            Spacer()
        }
        .padding(.small)
        .background(Color.white)
        .cornerRadius(.large)
        .modifier(ShadowModifier())
    }
}


struct BusinessCell_Previews: PreviewProvider {
    static var previews: some View {
        BusinessCell(business: Business(alias: nil, categories: [.init(alias: nil, title: "Cafe")], coordinates: nil, displayPhone: nil, distance: nil, id: nil, imageURL: "https://loremflickr.com/g/620/440/paris", isClosed: nil, location: nil, name: "Blue bottle", phone: nil, price: nil, rating: 4.5, reviewCount: nil, transactions: nil, url: nil))
    }
}

