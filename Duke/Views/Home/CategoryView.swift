//
//  CategoryView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/8/22.
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectedCategory : String
    let category: FoodCategory
    
    var body: some View {
        Button {
            selectedCategory = category.rawValue
        } label: {
            HStack {
                Text(category.emoji)
                    .font(.title)
                Text(category.rawValue.capitalized)
            }
        }
        .padding(.small)
        .padding(.horizontal, .medium)
        .background(selectedCategory == category.rawValue ? Color.black : Color.white)
        .cornerRadius(20)
        .padding(.top, .small)
        .padding(.bottom, .large)
        .foregroundColor(selectedCategory == category.rawValue ? Color.white : Color.black)
        .if(selectedCategory == category.rawValue) { view in
            view
                .buttonStyle(CapsuleButtonStyle())
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(selectedCategory: .constant(FoodCategory.coffee.rawValue), category: .coffee)
            .preferredColorScheme(.dark)
    }
}
