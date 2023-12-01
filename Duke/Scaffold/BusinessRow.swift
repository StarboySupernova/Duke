//
//  BusinessRow.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/4/23.
//

import SwiftUI

struct BusinessRow: View {
    var business: Business
    var size: CGSize
    
    var body: some View {
        HStack(alignment: .bottom) {
            //Labels
            VStack(alignment: .leading, spacing: .small) {
                Text(business.formattedName)
                Text(business.formattedCategory)
                HStack {
                    Text(business.formattedRating)
                    Image("star")
                }
            }
            .foregroundColor(.white)
            
            Spacer()
            
            AsyncImage(url: business.formattedImageURL ) { image in
                image
                    .resizable()
            } placeholder: {
                Color.blue.shimmer()
            }
            .frame(width: 90, height: 70)
            .cornerRadius(10)
            .padding(.small)
//            .modifier(CompactConvexGlassView())
        }
            .foregroundColor(.white)
            .font(.callout)
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: size.height)
            .background(Color("Background 2"), in: Trapezoid())
    }
}

//struct BusinessRow_Previews: PreviewProvider {
//    static var previews: some View {
//        BusinessRow()
//    }
//}
