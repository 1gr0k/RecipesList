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
    let extendedIngredients: [ExtendedIngredient]
}



struct ExtendedIngredient: Equatable, Identifiable {
    let id: Int
    let name: String
    let image: URL?
    
    init(model: ExtendedIngredientsRecipeDetailsCellViewModel) {
        self.id = model.id
        self.name = model.name
        self.image = model.image
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.image = nil
    }
}
