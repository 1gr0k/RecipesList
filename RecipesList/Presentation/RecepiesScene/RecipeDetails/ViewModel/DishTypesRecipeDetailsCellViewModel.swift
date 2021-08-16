//
//  DIshTypesRecipeDetailsCellViewModel.swift
//  DIshTypesRecipeDetailsCellViewModel
//
//  Created by Андрей Калямин on 13.08.2021.
//

import Foundation

class DishTypesRecipeDetailsCellViewModel: RecipeDetailCellViewModel {
    let dishTypes: [String]
    
    init(dishTypes: [String]) {
        self.dishTypes = dishTypes
    }
}
