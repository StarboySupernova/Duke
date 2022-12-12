//
//  CategoryView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/8/22.
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectedCategory : FoodCategory
    let category: FoodCategory
    
    var body: some View {
        Button {
            selectedCategory = category
        } label: {
            HStack {
                Text(category.emoji)
                    .font(.title)
                Text(category.rawValue.capitalized)
            }
        }
        .padding(.small)
        .padding(.horizontal, .medium)
        .background(selectedCategory == category ? Color.red : Color.white)
        .cornerRadius(20)
        .padding(.top, .small)
        .padding(.bottom, .large)
        .modifier(ShadowModifier())
        .foregroundColor(.black)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(selectedCategory: .constant(.coffee), category: .coffee)
    }
}
