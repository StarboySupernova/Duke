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
    @State private var showBooking: Bool = false
    var body: some View {
        //Booking button ought to come here
        ZStack(alignment: .topLeading) {
            ZStack {}
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.65)
                .background(RoundedCorners(topRight: 60.0,bottomLeft: 40.0,bottomRight: 40.0)
                    .fill(LinearGradient(gradient: Gradient(colors: [ColorConstants.RedA200,ColorConstants.PinkA100]),startPoint: .topLeading,endPoint: .bottomTrailing)))
                .shadow(color: ColorConstants.Black9003f, radius: 40,
                        x: 0, y: 20)
            
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 2) {
                    Group {
                        Text(businessDetail.formattedName)
                            .bold()
                            .foregroundColor(.offWhite)
                        Text(businessDetail.formattedCategories)
                            .font(.subheadline)
                            .padding(.bottom, .large)
                            .foregroundColor(.offWhite)
                    }
                    
                    Group {
                        HStack {
                            Image("map") //should include open map button on the space at the bottom
                            Button {
                                navigate()
                            } label: {
                                Text(businessDetail.formattedAddress)
                                    .foregroundColor(.offWhite)
                            }
                            Image("star")
                            Text(businessDetail.formattedRating)
                                .foregroundColor(.offWhite)
                            Image("money")
                            Text(businessDetail.formattedPrice)
                                .foregroundColor(.offWhite)
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
                                    .foregroundColor(.offWhite)
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
                        .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .bottomRight]))
                        .tabViewStyle(.page)
                    }
                }
                .padding(.xLarge)
                
                Button(action: {}, label: {
                    Image("pencil")
                })
                .frame(width: .xxLarge,
                       height: .xxLarge,
                       alignment: .center)
                .background(RoundedCorners(topLeft: 16.0,
                                           topRight: 16.0,
                                           bottomLeft: 16.0,
                                           bottomRight: 16.0)
                    .fill(Color.black))
            }
            .overlay(RoundedCorners(topRight: 0.0, bottomLeft: 40.0,
                                    bottomRight: 40.0)
                .stroke(Color.white.opacity(0.2),
                        lineWidth: 1))
            .background(RoundedCorners(topRight: 50.0, bottomLeft: 40.0,
                                       bottomRight: 40.0)
                .fill(Color.black.opacity(0.1)))
            .shadow(radius: 40)
        }
        .overlay(alignment: .bottom) {
            GradientButton(buttonTitle: "Make Booking") {
                showBooking = true
            }
            .padding(.bottom, .medium)
        }
        .padding(.xxLarge)
        .frame(maxWidth: .infinity, maxHeight: getRect().height * 0.65)
        .fullScreenCover(isPresented: $showBooking) {
            BookingView()
        }
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
            //.preferredColorScheme(.dark)
    }
}

