//
//  RecipeDetailsCellViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 26.07.2021.
//

import Foundation
import UIKit

class RecipeDetailsCellViewModel {
    
    private var recipe: DetailRecipe
    
    var imageS: String {
        return recipe.image
    }
    
    var dishTypes: [String] {
        return recipe.dishTypes
    }
    
    var extIngredients: [RecipesList.ExtIngredient] {
        return recipe.extendedIngredients
    }
    
    init(recipe: DetailRecipe) {
        self.recipe = recipe
    }
}
