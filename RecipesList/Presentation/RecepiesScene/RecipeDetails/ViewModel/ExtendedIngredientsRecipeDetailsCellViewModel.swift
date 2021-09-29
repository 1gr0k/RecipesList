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
    let image: URL
    
    init(id: Int, name: String, image: URL) {
        self.id = id
        self.name = name
        self.image = image
    }
}
