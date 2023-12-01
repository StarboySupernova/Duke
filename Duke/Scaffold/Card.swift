//
//  Card.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 8/4/23.
//

import SwiftUI


struct VCard: View {
    var business: Business
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(business.formattedName)
                .font(.title2)
                .frame(maxWidth: 170, alignment: .leading)
                .layoutPriority(1)
            
            Text(business.formattedCategory)
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text((business.location?.country!.uppercased())!)
                .font(.footnote)
                .opacity(0.7)
            
            Text((business.location?.city?.uppercased())!)
                .font(.footnote)
                .opacity(0.7)
            
            Spacer()
            HStack {
                ForEach(Array([4, 5, 6].shuffled().enumerated()), id: \.offset) { index, number in
                    Image("food\(number)")
                        .resizable()
                        .mask(Circle())
                        .frame(width: .xLarge, height: .xLarge)
                        .offset(x: CGFloat(index * -20))
                }
            }
        }
        .foregroundColor(.white)
        .padding(30)
        .frame(width: 150, height: 150)
        .background(
            AsyncImage(url: business.formattedImageURL ) { image in
                image
                    .resizable()
            } placeholder: {
                Color.blue.shimmer()
            }
        )
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: colors.randomElement()!.opacity(0.3), radius: 2, x: 0, y: 12)
        .shadow(color: colors.randomElement()!.opacity(0.3), radius: 1, x: 0, y: 1)
        .overlay(
            .linearGradient(colors: [colors.randomElement()!.opacity(0.25), .black.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
        )
    }
}

//struct VCard_Previews: PreviewProvider {
//    static var previews: some View {
//        VCard(course: courses[1])
//    }
//}

