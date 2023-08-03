//
//  ForecastCard.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 8/3/23.
//

import SwiftUI

struct TitleCard: View {
    var isActive: Bool
    var headingText: String
    var imageName: String
    
    var body: some View {
        ZStack {
            // MARK: Card
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.forecastCardBackground.opacity(isActive ? 1 : 0.2))
                .frame(width: getRect().width * 0.5, height: getRect().height * 0.05)
                .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 4)
                .overlay {
                    // MARK: Card Border
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(.white.opacity(isActive ? 0.5 : 0.2))
                        .blendMode(.overlay)
                }
                .innerShadow(shape: RoundedRectangle(cornerRadius: 30), color: .white.opacity(0.25), lineWidth: 1, offsetX: 1, offsetY: 1, blur: 0, blendMode: .overlay)
            
            // MARK: Content
            HStack(spacing: .large) {
                // MARK: Forecast Date
                Text(headingText)
                    .font(.subheadline.weight(.semibold))
                
                Image(systemName: imageName)
            }
            .padding(.horizontal, .medium)
            .frame(width: getRect().width * 0.5, height: getRect().height * 0.05)
        }
    }
}

struct TitleCard_Previews: PreviewProvider {
    static var previews: some View {
        TitleCard(isActive: false, headingText: "Home", imageName: "person.fill")
    }
}
