//
//  RecepiesRequestDTO+Mapping.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

struct RecipesRequestDTO: Encodable {
    let query: String
    let offset: Int
    let number: Int
}
