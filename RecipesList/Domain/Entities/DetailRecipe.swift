//
//  DetailRecipe.swift
//  RecipesList
//
//  Created by Андрей Калямин on 23.07.2021.
//

import Foundation

struct DetailRecipe: Equatable, Identifiable {
    let id: String
    let title: String
    let image: String
    let dishTypes: [String]
    let extendedIngredients: [ExtIngredient]
}



struct ExtIngredient: Equatable, Identifiable {
    let id: Int
    let name: String
}
