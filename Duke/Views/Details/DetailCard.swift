//
//  DetailCard.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/9/22.
//

import SwiftUI
import ExtensionKit

struct DetailCard: View {
    let businessDetail: BusinessDetails
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Group {
                Text(businessDetail.formattedName)
                    .bold()
                Text(businessDetail.formattedCategory)
                    .font(.subheadline)
            }
            
            Group {
                HStack {
                    Image("map")
                    Text(businessDetail.formattedAddress)
                    Image("star")
                    Text(businessDetail.formattedRating)
                    Image("money")
                    Text(businessDetail.formattedPrice)
                }
                .padding(.bottom, .small)
            }
            
            Group {
                HStack {
                    Image("clock")
                    Text("Open")
                    Image("phone")
                    Text(businessDetail.formattedPhoneNumber)
                    Spacer() //Spacer affects other groups in same VStack
                }
            }
            
            Group {
                TabView {
                    ForEach(businessDetail.images, id: \.self) { url in
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.shimmer()
                        }
                    }
                }
                .frame(height: 250)
                .cornerRadius(.large)
                .tabViewStyle(.page)
            }
        }
        .padding()
        .padding() //hacky
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.6)
    }
}


struct DetailCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailCard(businessDetail: .init(id: nil, alias: nil, name: "Sweetgreen", imageURL: "https://loremflickr.com/g/620/440/paris", isClaimed: nil, isClosed: nil, url: nil, phone: nil, displayPhone: "(555) 895-007", reviewCount: nil, categories: [.init(alias: nil, title: "Cafe")], rating: 4.5, location: nil, coordinates: nil, photos: ["https://loremflickr.com/g/620/440/paris", "https://loremflickr.com/g/620/440/paris"], price: "$", hours: nil, transactions: nil))
        //DetailCard(businessDetail: BusinessDetails(alias: nil, categories: [.init(alias: nil, title: "Cafe")], coordinates: nil, displayPhone: nil, distance: nil, id: nil, imageURL: "https://loremflickr.com/g/620/440/paris", isClaimed: nil, isClosed: nil, dateOpened: nil, dateClosed: nil, location: nil, name: "Blue bottle", phone: nil, photos: ["https://loremflickr.com/g/620/440/paris", "https://loremflickr.com/g/620/440/paris"], price: nil, rating: 4.5, reviewCount: nil, hours: nil, specialHours: nil, transactions: nil, url: nil, attributes: nil, messaging: nil))
        //DetailCard(business: Business(alias: nil, categories: [.init(alias: nil, title: "Cafe")], coordinates: nil, displayPhone: nil, distance: nil, id: nil, imageURL: "https://loremflickr.com/g/620/440/paris", isClosed: nil, location: nil, name: "Blue bottle", phone: nil, price: nil, rating: 4.5, reviewCount: nil, transactions: nil, url: nil))
    }
}

