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

#warning("pinned note")
///major tabs needed here - home, bookings , favourites, settings, create. create allowed here however this will show created reviews, and an option to go create new ones
///restaurant search is in home
///account will be brought up on every view. if user is logged in, it goes straight to chat features. Chat features will have a segmented control between chat and video creation
