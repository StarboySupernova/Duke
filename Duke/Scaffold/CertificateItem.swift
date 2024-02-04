//
//  CertificateItem.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/7/23.
//

import SwiftUI

struct TrendingBusinessItem: View {
    var switchButtonText: String = "More"
    var switchButtonImage: String = ""
    var business: Business
    var color1: Color = Color(red: 0.992, green: 0.247, blue: 0.2)
    var color2: Color = Color(red: 0.298, green: 0, blue: 0.784)

    @Binding var show: Bool

    #if os(iOS)
    var cornerRadius: CGFloat = 25
    #else
    var cornerRadius: CGFloat = 10
    #endif

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(business.formattedName)
                        .font(.system(size: 17, weight: .bold))
                        .bold()
                        .foregroundColor(.white)
                        .animation(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(business.formattedCategory)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .opacity(0.8)
                    
                    AsyncImage(url: business.formattedImageURL) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Color.blue.shimmer()
                    }
                    .frame(width: 110, height: 110)
                    .cornerRadius(10)
                    .padding(.small)
                }
                Spacer()
                HStack(spacing: .small) {
                    Text(switchButtonText)
                    Image(systemName: switchButtonImage)
                }
                .foregroundColor(.white)
                .padding(.horizontal, .medium)
                .padding(.vertical, .small)
                .background(Color.white.opacity(0.2))
                .mask(Capsule())
                .shadow(radius: 30)
                .onTapGesture {
                    show.toggle()
                }
            }
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                }
            }
            Rectangle()
                .frame(width: CGFloat.random(in: 60...140), height: 8)
                .cornerRadius(4)
                .foregroundColor(.white)
                .opacity(0.5)
        }
        .padding(16)
        .background(
            ZStack {
                RadialGradient(gradient: Gradient(colors: [color1, color2]), center: .topLeading, startRadius: 5, endRadius: 500)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: color2.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}


struct TrendingBusinessItem_Previews: PreviewProvider {
    static var previews: some View {
        TrendingBusinessItem(business: Business(alias: nil, categories: [.init(alias: nil, title: "Cafe")], coordinates: nil, displayPhone: nil, distance: nil, id: nil, imageURL: "https://loremflickr.com/g/620/440/paris", isClosed: nil, location: nil, name: "Blue bottle", phone: nil, price: nil, rating: 4.5, reviewCount: nil, transactions: nil, url: nil), show: .constant(true))
    }
}
