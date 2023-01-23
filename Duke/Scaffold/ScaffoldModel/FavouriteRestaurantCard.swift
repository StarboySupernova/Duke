//
//  FavouriteRestaurantCard.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/19/23.
//

import Foundation

struct FavouriteRestaurantCard : Identifiable {
    var id: UUID = .init()
    var cardImage: String
}

var sampleCards: [FavouriteRestaurantCard] = [
    .init(cardImage: "exterior1"),
    .init(cardImage: "exterior3"),
    .init(cardImage: "exterior4"),
    .init(cardImage: "exterior6"),
    .init(cardImage: "exterior3"),
    .init(cardImage: "exterior1"),
    .init(cardImage: "exterior4"),
]
