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
                Text(businessDetail.formattedCategories)
                    .font(.subheadline)
                    .padding(.bottom, .large)
            }
            
            Group {
                HStack {
                    Image("map")
                    Button {
                        navigate()
                    } label: {
                        Text(businessDetail.formattedAddress)
                    }
                    Image("star")
                    Text(businessDetail.formattedRating)
                    Image("money")
                    Text(businessDetail.formattedPrice)
                }
                .font(.subheadline)
            }
            
            Group {
                HStack {
                    Image("clock")
                    Text(businessDetail.dayOfTheWeek)
                    Image("phone")
                    Button {
                        phone()
                    } label: {
                        Text(businessDetail.formattedPhoneNumber)
                    }

                    Spacer() //Spacer affects other groups in same VStack
                }
                .font(.subheadline)
                .padding(.bottom, .large)
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
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.65)
    }
    
    func phone () {
        UIApplication.shared.openPhone(calling: businessDetail.phone ?? "")
    }
    
    func navigate () {
        let query : String = "\(businessDetail.coordinates?.latitude ?? 0),\(businessDetail.coordinates?.longitude ?? 0)"
        UIApplication.shared.openExternalMapApp(query: query)
    }
}


struct DetailCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailCard(businessDetail: .init(id: nil, alias: nil, name: "Sweetgreen", imageURL: "https://loremflickr.com/g/620/440/paris", isClaimed: nil, isClosed: nil, url: nil, phone: nil, displayPhone: "(555) 895-007", reviewCount: nil, categories: [.init(alias: nil, title: "Cafe")], rating: 4.5, location: nil, coordinates: nil, photos: ["https://loremflickr.com/g/620/440/paris", "https://loremflickr.com/g/620/440/paris"], price: "$", hours: nil, transactions: nil))
    }
}

