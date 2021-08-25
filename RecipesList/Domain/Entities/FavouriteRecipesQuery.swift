//
//  FavouriteRecipesQuery.swift
//  FavouriteRecipesQuery
//
//  Created by Андрей Калямин on 05.08.2021.
//

import Foundation

struct FavouriteRecipesQuery: Equatable {
    let query: String
    
    init(favouriteRecipes: FavouriteRecipes) {
        var array: [String] = []
        favouriteRecipes.recepies.forEach { array.append($0.id) }
        self.query = array.joined(separator: ",")
    }
}

