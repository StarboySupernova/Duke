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
    .init(cardImage: "groceries"),
    .init(cardImage: "groceries"),
    .init(cardImage: "groceries"),
    .init(cardImage: "groceries"),
    .init(cardImage: "groceries"),
    .init(cardImage: "groceries"),
]
