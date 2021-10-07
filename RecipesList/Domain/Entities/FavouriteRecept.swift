//
//  FavouriteRecept.swift
//  FavouriteRecept
//
//  Created by Андрей Калямин on 03.08.2021.
//

import Foundation

struct FavouriteRecept: Identifiable, Equatable, Hashable {
    let id: String
    let title: String?
    let image: String?
}

struct FavouriteRecipes {
    let recepies: [FavouriteRecept]
}
