//
//  ExtendedIngredientsRecipeDetailsCellViewModel.swift
//  ExtendedIngredientsRecipeDetailsCellViewModel
//
//  Created by Андрей Калямин on 13.08.2021.
//

import Foundation

class ExtendedIngredientsRecipeDetailsCellViewModel: RecipeDetailCellViewModel {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
