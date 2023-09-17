//
//  FavoritedLocation.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/17/23.
//

import Foundation

struct FavoritedLocation: Identifiable, Hashable {
    var id: String
    var city: String
    var favorited: Bool
    var latitude: Double
    var longitude: Double
}

